### 4.3 API Deprecations and Stability
<img src="../images/image-15.png" alt="4.3 API Deprecations and Stability" height="35%" width="35%" />

Kubernetes maintains a strict policy regarding API stability. With new Kubernetes releases, older API versions may get deprecated.

**Deprecation Policy:**
If an old version is marked for deprecation, it will be supported for a **minimum of two more Kubernetes releases**. This ensures that users have enough time to migrate their configurations.

**Action Required:**
When you see a deprecation message, or when updating your cluster to a new major version, make sure to take action and change your YAML manifest files to use the newer, stable API version!

### Demo: Dealing with Removed API (apps/v1beta1 Example)

This demonstration shows the error encountered when trying to use an API version (`apps/v1beta1`) that has been completely removed from the current Kubernetes cluster.

1. **Attempt to Create Resource with Removed API:**
   (Assuming `redis-deploy.yaml` uses `apiVersion: apps/v1beta1`)
   ```bash
   kubectl create -f redis-deploy.yaml
   ```

   **Expected Error:**
   ```
   error: unable to recognize "redis-deploy.yaml": no matches for kind "Deployment" in version “apps/v1beta1"
   ```

2. **Check Available API Versions:**
   Use this command to see what API groups and versions the current cluster supports:
   ```bash
   kubectl api-versions
   ```

3. **Examine the Correct/Stable API Structure:**
   You can use `kubectl explain` to find the current structure of the resource (which will default to the stable `apps/v1` version for `Deployment`):
   ```bash
   kubectl explain --recursive deploy
   ```

### Demo: Using the Stable API (apps/v1)

Once you correct your `redis-deploy.yaml` file to use the stable `apiVersion: apps/v1`, the resource creation will succeed.

1. **Create Resource with Stable API:**
   (Assuming `redis-deploy.yaml` now uses `apiVersion: apps/v1`)
   ```bash
   kubectl create -f redis-deploy.yaml
   ```

[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
