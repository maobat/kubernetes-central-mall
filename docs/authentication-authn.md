<h2 id="section-4-4-1">4.4.1 Authentication (AuthN)</h2>

**Authentication is about proving *who* you are.** It is the process of verifying a user's or system's identity.

| Kubernetes Concept | Mall Analogy | Description |
| :--- | :--- | :--- |
| **Authentication** | **Employee ID Badge Check-in** | Proving identity at the security desk (e.g., username/password, token, or certificate). |
| **Default User** | **Local Admin Account** | By default, local Kubernetes setups often use a trusted admin account where authentication is implicitly handled by certificates. |
| **\`kubeconfig\` File** | **The Security Credential Card** | The local file (\`~/.kube/config\`) that specifies which cluster to authenticate to, and what credentials (user, certificate, or token) to use. |

In more advanced setups (e.g., cloud providers), you can create your own user accounts that leverage external identity providers (covered in depth in CKA).

**Demo: Viewing Current Authentication Settings**

The `kubectl config` command manages the local configuration file.
```bash
kubectl config view
# Shows current settings, including the cluster, user, and context being used.
```
The configuration is read from:
```bash
less ~/.kube/config
# Displays the content of the configuration file.
```