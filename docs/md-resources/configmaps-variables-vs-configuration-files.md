## 4.1.4 ConfigMaps: Variables vs. Configuration Files
The method you use to expose a ConfigMap depends entirely on what it holds:

| Type | Data Format in ConfigMap | How it's Used in Pod |
| :--- | :--- | :--- |
| **Variables** | Key-Value pairs (e.g., `MYSQL_USER=anna`) | Injected as Environment Variables into the container's shell. |
| **Config Files** | Full file content (e.g., the content of index.html) | Mounted as Files into the container's filesystem. |

#### ⚙️ Using ConfigMaps for Environment Variables (Variables)

This method is best for simple, application-level settings.

**A. Creating the ConfigMap**

You have two main imperative ways to create ConfigMaps containing key-value pairs:

**From Literal Values:**
```bash
kubectl create cm mycm --from-literal=MYSQL_USER=anna --from-literal=MYSQL_DATABASE=appdb
```

**From an Environment File (recommended):**
```bash
# varsfile content:
# MYSQL_ROOT_PASSWORD=password
# MYSQL_USER=anna
kubectl create cm mydbvars --from-env-file=varsfile
```

**B. Consuming the ConfigMap (Deployment Injection)**

The key to using variables from a ConfigMap is the `kubectl set env` command, which is an imperative way to modify a Deployment:

```bash
kubectl set env deploy mydb --from=configmap/mydbvars
```

This command modifies the Deployment to pull all key-value pairs from the `mydbvars` ConfigMap and inject them as environment variables into the Pods.

#### 📄 Using ConfigMaps for Configuration Files (Files)

This method is necessary when an application needs its configuration in the form of a file (like `nginx.conf` or an `index.html` file).

**A. Creating the ConfigMap**

You create the ConfigMap from the actual file(s) you want to store:

**From a Single File:**
```bash
# Stores the content of index.html under the key 'index.html'
kubectl create cm myindex --from-file=index.html
```

**B. Consuming the ConfigMap (Volume Mounting)**

When mounting configuration files, you must use the declarative YAML approach. The process involves two steps in the Pod/Deployment manifest:

1.  **Define a Volume:** Inside `spec.template.spec.volumes`, you define a volume of `configMap` type and point it to the ConfigMap name.

2.  **Mount the Volume:** Inside `spec.template.spec.containers.volumeMounts`, you specify where that volume should appear in the container's filesystem.

```yaml
# Example Pod Snippet for Volume Mounting
volumes:
- name: cmvol
  configMap:
    name: myindex # Refers to the ConfigMap created above
containers:
- name: nginx-container
  image: nginx
  volumeMounts:
  - mountPath: /usr/share/nginx/html # Nginx's default document root
    name: cmvol
```
When the Pod runs, the key (`index.html`) inside the ConfigMap appears as a file named `index.html` at the specified `mountPath`.


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
