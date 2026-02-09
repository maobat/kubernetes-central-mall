<h2 id="section-4-2-3">4.2.3 Connecting to the API via Proxy Tunnel</h2>

To safely access the API using local tools like \`curl\`, you start the Kubernetes proxy on your local workstation.

1.  **Start the Proxy:**
    ```bash
    kubectl proxy --port=8001 &
    ```
    *This command runs in the background, forwarding local requests on port 8001 securely to the API server.*

2.  **Access the API Root:**
    ```bash
    curl http://localhost:8001
    ```
    *This request, now proxied securely, will return a JSON object listing all available API paths and groups, providing access to all exposed Kubernetes functions.*
