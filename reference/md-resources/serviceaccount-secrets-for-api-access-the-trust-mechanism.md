## 4.1.2 Key Concept: ServiceAccount, Secrets for API Access
All resources within Kubernetes that need to interact with the Kubernetes API require proper authentication and authorization.

* **ServiceAccounts (SA):** Every Pod runs under a ServiceAccount (either default or specified), granting it an identity.
* **TLS Keys:** The necessary Transport Layer Security (TLS) keys (certificate authority, token, and namespace) are required for API authentication.
* **Automatic Mounting (Older Versions):** In older Kubernetes versions (pre-1.24), a dedicated Secret object containing the ServiceAccount token was automatically created and mounted into the Pod at `/var/run/secrets/kubernetes.io/serviceaccount`.

#### Kubernetes Version Difference & Manual Token Patching

Modern Kubernetes (v1.24+) relies on **Projected Volume Tokens** for short-lived, secure access, meaning the dedicated, long-lived Secret is no longer automatically created. This change can break legacy components (like CoreDNS) expecting the Secret to exist.

To fix this, we must manually create and link a token Secret to the ServiceAccount.

**Step 1: Define the Base64 Encoded Data**

To manually create a ServiceAccount Token Secret, you need the following Base64-encoded data (JWT token, CA certificate, and namespace):

| Field Name | Description Placeholder | Value (Base64) |
| :--- | :--- | :--- |
| `token` | The JWT used for API authentication. | `c2VydmljZWFjY291bnQtdG9rZW4=` |
| `ca.crt` | The CA certificate for API server TLS verification. | `Y2xpZW50LWNhLWNlcnRpZmljYXRl` |
| `namespace` | The namespace of the Secret. | `a3ViZS1zeXN0ZW0=` |

**Step 2: Create the Secret Manifest (coredns-secret.yaml)**

This manifest uses the `kubernetes.io/service-account-token` type and links to the `coredns` ServiceAccount:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: coredns-manual-token # CRITICAL: Must match the name linked in the SA
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: coredns
type: kubernetes.io/service-account-token # CRITICAL: Specifies the token Secret structure
data:
  # Base64 encoded values for token, ca.crt, and namespace:
  token: c2VydmljZWFjY291bnQtdG9rZW4=
  ca.crt: Y2xpZW50LWNhLWNlcnRpZmljYXRl
  namespace: a3ViZS1zeXN0ZW0=
```

**Step 3: Apply the Manifest (The Fix)**

```bash
kubectl apply -f coredns-secret.yaml
# Patch the ServiceAccount to reference the new token Secret (required for legacy compatibility)
kubectl patch sa coredns -n kube-system -p '{"secrets": [{"name": "coredns-manual-token"}]}'
```


[Back to Documentation](../README.md)
