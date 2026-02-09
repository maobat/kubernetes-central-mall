## 4.1.3 Secrets: Use Cases and Application Integration
Secrets are used to hold sensitive data. Since a Secret is essentially a Base64-encoded ConfigMap, it can be mounted or injected into a Pod in similar ways.

#### A. Secret Creation Use Cases

Different types of secrets are created based on the kind of data they hold:

| Use Case | Command Example | Secret Type |
| :--- | :--- | :--- |
| **TLS Certificates/Keys** | `kubectl create secret tls my-tls-keys --cert=tls/my.crt --key=tls/my.key` | `kubernetes.io/tls` |
| **Generic Passwords** | `kubectl create secret generic my-secret-pw --from-literal=password=verysecret` | `Opaque` |
| **SSH Private Key** | `kubectl create secret generic my-ssh-key --from-file=ssh-private-key=.ssh/id_rsa` | `Opaque` |
| **Sensitive File** | `kubectl create secret generic my-secret-file --from-file=/my/secretfile` | `Opaque` |
| **Container Registry Auth** | `kubectl create secret docker-registry my-docker-credentials --docker-username=... ` | `kubernetes.io/docker-registry` |

##### Registry Authentication Decoupling

To pull images from private container registries (like Docker Hub or a private corporate registry), additional authentication is required.

* On a stand-alone container node, these credentials would be stored in a local config file.
* In a cloud-native environment, the authentication information should be decoupled from the nodes and stored centrally using a Secret.
* Use the `docker-registry` Secret type to store the authentication credentials in a Secret.

#### B. Walkthrough: Authenticating Image Pulls (`docker-registry` Secret)

These commands demonstrate the creation and inspection of a `docker-registry` Secret in Kubernetes. This type of Secret is specifically used to store credentials required for Pods to pull images from a private container registry.

**🚀 1. Creating the Secret**

```bash
kubectl create secret docker-registry my-docker-credentials \
    --docker-username=unclebob \
    --docker-password=secretpw \
    --docker-email=uncle@bob.org \
    --docker-server=myregistry:5000
```

**Explanation:**
* **`kubectl create secret docker-registry`:** Tells Kubernetes to create a Secret specifically of the type `kubernetes.io/dockerconfigjson`.
* **`my-docker-credentials`:** This is the name of the Secret being created.
* **`--docker-server=myregistry:5000`:** The URL of the private container registry.
* **`--docker-username=... / --docker-password=...`:** The credentials used for authentication against that registry.
* **Result:** Kubernetes automatically creates a Base64-encoded JSON object that mimics the standard Docker configuration file (`~/.docker/config.json`) and stores it as data in the Secret.

**🔎 2. Basic Inspection**

```bash
k get secrets my-docker-credentials
```

| Column | Value | Notes |
| :--- | :--- | :--- |
| **NAME** | `my-docker-credentials` | The name you assigned. |
| **TYPE** | `kubernetes.io/dockerconfigjson` | Confirms the type is for private registry access. |
| **DATA** | `1` | Indicates there is one primary data field in the Secret (the `.dockerconfigjson` entry). |

**📝 3. Detailed Inspection**

```bash
k describe secret my-docker-credentials
```

> **Output Notes:**
The `describe` command provides a human-readable summary of the Secret.
* **Type:** `kubernetes.io/dockerconfigjson`
* **Data:** `.dockerconfigjson: XXX bytes` (Shows the size of the encoded credential data, but not the contents).

**🔑 4. Viewing Raw Encoded Content**

```bash
k get secrets my-docker-credentials -o yaml
```

> **Output Notes:**
* Using `-o yaml` retrieves the Secret's full YAML definition, including the Base64-encoded credential data.
* The key field is `.dockerconfigjson`, which holds the Base64 representation of the JSON data structure containing the registry credentials.
* **Crucial Note:** This output is not the plain text password. You must Base64-decode this string to view the raw credentials.

**Next Steps: Linking the Secret to a Pod**

Once this Secret is created, the final step is to reference it so that Kubernetes knows to use these credentials when pulling the image. You add the Secret name to the `imagePullSecrets` field of the ServiceAccount used by the Pod:

```yaml
# Example snippet for a ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-app-sa
imagePullSecrets:
- name: my-docker-credentials
```

#### C. Consuming Secrets in Applications

There are two primary ways applications consume Secrets:

1.  **Environment Variables:** Best for single, simple values (like passwords).
    * Use the `kubectl set env` command (often used with Deployments).

2.  **Volume Mounts:** Best for files, certificates, or when fine-grained file permissions are needed.
    * Mount the Secret as a volume in the Pod specification.



---

### Security and Maintenance of Mounted Secrets

#### 1. Permission Control with `defaultMode`

When you mount a Secret as a volume, you are placing its key-value pairs as individual files inside the container's filesystem. The `defaultMode` setting allows you to control the Unix file permissions applied to these created files.

**Why It's Important**
By default, files created from Secrets and ConfigMaps are usually readable by everyone in the container (often `0644`). For highly sensitive data, this is often too permissive. Using `defaultMode` lets you restrict who can read the secret files, often limiting access to just the process owner (the user running the application).

**Example Usage:**
* **`defaultMode: 0400`:** This sets the files to be read-only by the owner (`r--------`). This is a common secure setting for sensitive files like private keys.
* **`defaultMode: 0640`:** Read/write for the owner, read-only for the group (`rw-r-----`).

**Implementation Snippet**
You define `defaultMode` within the volume definition section of your Deployment/Pod specification.

```yaml
# ... inside spec.template.spec
volumes:
- name: secret-volume
  secret:
    secretName: my-tls-secret
    defaultMode: 0400  # Sets permissions on the mounted files
# ...
containers:
- name: my-app
  volumeMounts:
  - name: secret-volume
    mountPath: "/etc/secrets"
```

#### 2. Automatic Updating of Mounted Secrets

One of the most powerful features of mounted Secrets is that they are not static. If you update the contents of the underlying Secret object in Kubernetes, the files mounted inside your running Pod will automatically update themselves.

**How It Works**
* Kubernetes periodically checks for changes to Secret and ConfigMap objects.
* When a change is detected, the **kubelet** on the node updates the file content in the mounted directory.
* This update is **eventual consistency**, it typically takes a few seconds (e.g., 10-60 seconds) to propagate, but it **does not require the Pod or container to be restarted**.

**Why It's Useful**
* **Zero Downtime Credential Rotation:** You can update a database password or API key in the Secret without taking down the application Pods that rely on that credential, assuming the application is built to detect file changes.

**Caveat (Application Awareness)**
While the file is updated on the filesystem, the application itself must be configured to re-read the file from the disk. Most applications only read configuration files once at startup. If your application caches the credential in memory, it won't pick up the change until it's restarted. **Applications using environment variables (instead of mounted files) will generally require a Pod restart to pick up the updated value.**

---
#### D. Demo: Using a Secret to Provide Database Passwords

This walkthrough demonstrates creating a generic password Secret and injecting it into a MariaDB Deployment as an environment variable.

1.  **Create the Secret:**
    ```bash
    kubectl create secret generic dbpw --from-literal=ROOT_PASSWORD=password
    ```

2.  **Inspect the Secret's Details (Base64 encoded):**
    ```bash
    kubectl describe secret dbpw
    kubectl get secret dbpw -o yaml
    ```

3.  **Create the Database Deployment:**
    ```bash
    kubectl create deployment mynewdb --image=mariadb
    ```

4.  **Inject the Secret's Content as Environment Variables:**
    *The prefix `MYSQL_` is needed for the MariaDB image to recognize the variable as a configuration setting.*
    ```bash
    kubectl set env deployment mynewdb --from=secret/dbpw --prefix=MYSQL_
    ```

**Result:** The MariaDB Pod will now run with an environment variable named `MYSQL_ROOT_PASSWORD` set to the value stored in the `dbpw` Secret.


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
