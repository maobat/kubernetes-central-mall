<h2 id="section-4-5-0">4.5 Understanding ServiceAccounts (The Shop's Internal Badge)</h2>

### Managing ServiceAccounts

Every Namespace has a default ServiceAccount called `default`. This SA has minimal permissions, generally allowing a Pod to view its own status, but it **cannot** list other resources like Pods or Services.

Additional ServiceAccounts can be created to provide specific, tailored access to resources. After creating a custom ServiceAccount, it *must* be granted permissions through RBAC (Roles and RoleBindings).

**Creating Additional Service Accounts**
ServiceAccounts are easily created using the imperative way:

```bash
kubectl create serviceaccount mysa
# Output: serviceaccount/mysa created
```

When a ServiceAccount is created, a Secret or token is automatically projected into Pods that use it, allowing the Pod to connect to the API. This token is mounted into Pods using the ServiceAccount and used as an access token.

### Demo 1: Using the Default ServiceAccount (mypod.yaml) (Limited Access)

This demo proves that the default ServiceAccount token cannot list resources other than its own status.

**Pod Definition (using implicit 'default' SA)**

```
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  # serviceAccountName is implicitly 'default' if not specified
  containers:
  - name: alpine
    image: alpine/curl
    command:
    - "sleep"
    - "3600"

```

**CLI Steps (Forbidden Access):**

1. Apply the Pod:
   ```bash
   kubectl apply -f my-pod.yaml
   # Output: mypod created
   ```
2. Access the Pod and try to list Pods via the API:
   ```bash
   kubectl exec -it mypod -- sh
   / # apk add --update curl
   
   # Get the token provided by the default ServiceAccount
   / # TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
   
   # Attempt to list Pods in the default namespace
   / # curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure
   
   # Output showing failure:
   "reason": "Forbidden",
   "message": "pods is forbidden: User \"system:serviceaccount:default:default\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
   "code": 403
   ```
The attempt is forbidden because the `default` ServiceAccount is not bound to any Role granting `list` permission for `pods`.


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
