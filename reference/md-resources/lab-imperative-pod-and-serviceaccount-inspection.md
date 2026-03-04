<h2 id="section-4-6-2">4.6.2 Lab: Imperative Pod and ServiceAccount Inspection</h2>

This quick lab demonstrates how to use the imperative approach (`kubectl run`) to generate the YAML manifest for a Pod and inspect the automatic inclusion of the default ServiceAccount setting, which is the baseline configuration being overridden by the custom RBAC setup above.

```bash
# 1. Review available options for kubectl run
kubectl run --help | less

# 2. Generate a YAML manifest (dry-run) for a busybox Pod named 'bysysa'
# The result is redirected to a local file, 'bysysa.yaml'
kubectl run bysysa --image=busybox -o yaml --dry-run=client -- sleep 3600 > bysysa.yaml

# 3. Edit the file (or simply view it) to check the Pod specification.
# Note: The 'serviceAccountName: default' is often implicit but implied in the spec.
vim bysysa.yaml

# 4. Create the Pod from the generated file
kubectl create -f bysysa.yaml

# 5. Inspect the live Pod's final YAML to confirm the ServiceAccount is set.
kubectl get pods bysysa -o yaml | less
```


[Back to Documentation](../README.md)
