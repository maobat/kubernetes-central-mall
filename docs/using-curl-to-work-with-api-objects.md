<h2 id="section-4-2-4">4.2.4 Using `curl` to Work with API Objects</h2>

Once the `kubectl proxy` is running, you can use standard RESTful commands via `curl` to interact directly with the API server, bypassing the `kubectl` CLI utility.

**Demo: Using `curl` to Access API Resources**

1.  **Start the Proxy (if not already running):**
    This establishes the secure, authenticated tunnel from your local machine (port 8001) to the API server.
    ```bash
    kubectl proxy --port=8001 &
    ```

2.  **Create Test Deployment:**
    We need resources to query and delete.
    ```bash
    kubectl create deploy curl-test --image=nginx --replicas=3
    ```

3.  **Check API Server Version:**
    A basic `GET` request to the root path `/version`.
    ```bash
    curl http://localhost:8001/version
    ```

4.  **List Pods in the `default` Namespace (GET):**
    This shows the API path structure: `/api/v1/namespaces/{namespace}/pods`.
    ```bash
    curl http://localhost:8001/api/v1/namespaces/default/pods
    ```

5.  **View a Specific Pod (GET):**
    To target a specific object, you must append the resource name. *Note: You need the full Pod name, not the Deployment name.*
    ```bash
    # Step 5a: Get a full Pod name first (e.g., curl-test-77c98f8674-w2rtj)
    POD_NAME=$(kubectl get pods -l app=curl-test -o jsonpath='{.items[0].metadata.name}')
    # Step 5b: Access the specific Pod's definition
    curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME
    ```

6.  **Delete a Specific Pod (DELETE):**
    Using the HTTP `DELETE` method on the resource endpoint removes the object. The Deployment will automatically recreate it.
    ```bash
    # Using the Pod name obtained above
    curl -XDELETE http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME
    ```

7.  **Review Authentication Configuration:**
    The security context for all `kubectl` and proxied requests is defined in the configuration file on the user's workstation.
    ```bash
    cat ~/.kube/config
    ```