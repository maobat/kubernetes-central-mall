<h2 id="section-4-4-2">4.4.2 Authorization (AuthZ)</h2>

Authorization is about determining **what you can do** once authenticated. Behind authorization, Kubernetes uses **Role-Based Access Control (RBAC)** to manage permissions.
**Demo: Checking User Capabilities**

You can use the `kubectl auth can-i` command to check if a user (or the current user) is authorized to perform a specific action (verb) on a specific resource.

```bash
# Check what the current user can do (e.g., the kubeconfig user)
kubectl auth can-i get pods

# Check what a hypothetical external user ('bob') can do
kubectl auth can-i get pods --as bob@example.com
# If Bob is not bound to a role, this will likely return 'no'.
```

[Back to Documentation](../README.md)
