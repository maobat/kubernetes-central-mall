<h2 id="section-4-6-1">4.6.1 Defining the Custom Components</h2>

**A. Custom ServiceAccount (`mysa.yaml`):**
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: mysa
  namespace: default
```

**B. Role Definition (`list-pods.yaml`): The Job Description**

This Role grants only the ability to **list** Pods in the `default` namespace.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: list-pods
  namespace: default
rules:
  - apiGroups:
    - ''          # '' represents the core API group (v1 resources: Pods, Services, etc.)
    resources:
    - pods        # The resource this Role applies to
    verbs:
    - list        # Actions allowed

```

**C. RoleBinding Definition (`list-pods-mysa-binding.yaml`): The HR Assignment Letter**

This object connects the `mysa` ServiceAccount to the `list-pods` Role.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: list-pods-mysa-binding
  namespace: default
roleRef:
  kind: Role
  name: list-pods
  apiGroup: rbac.authorization.k8s.io
subjects:
  - kind: ServiceAccount
    name: mysa
    namespace: default
```

### Demo 2: Using Custom SA for Access (Gaining Permission)

**1. Create the RBAC resources:**
```bash
kubectl apply -f mysapod.yaml
kubectl apply -f list-pods.yaml
kubectl apply -f list-pods-mysa-binding.yaml
```

**2. Pod Definition using Custom SA (`pod-custom-sa.yaml`):**

```
apiVersion: v1
kind: Pod
metadata:
  name: mysapod
spec:
  serviceAccountName: mysa # Explicitly use the custom SA 'mysa'
  containers:
  - name: alpine
    image: alpine:3.9
    command: ["sleep", "3600"]
```

**3. Run the Pod and verify successful access:**
```bash
kubectl apply -f pod-custom-sa.yaml
# Output: pod/mysapod created

kubectl exec -it mysapod -- sh
/ # apk add --update curl

# Get the token provided by the 'mysa' ServiceAccount
/ # TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)

# Attempt to list Pods - THIS SHOULD NOW SUCCEED
/ # curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure

# Expected Successful Output:
{
  "kind": "PodList",
  "apiVersion": "v1",
  "metadata": { ... },
  "items": [
    # ... pod definitions will be listed here, confirming success
  ]
}
```
The access is granted because the Pod is using the `mysa` ServiceAccount, which is **bound** to the `list-pods` Role, granting the required permission.


[Back to Documentation](../README.md)
