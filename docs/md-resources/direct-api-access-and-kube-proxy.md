### 4.2.2 Direct API Access and \`kube-proxy\`
<img src="../images/image-16.png" alt="4.2.2 Direct API Access and \`kube-proxy\" height="35%" width="35%" />

The Kubernetes APIs are **RESTful**, meaning they can be accessed directly using standard HTTP requests. This is useful when \`kubectl\` might not be available or for scripting purposes.

* **Under the Hood:** \`kubectl\` itself makes secured RESTful API requests. You can inspect the underlying request that \`kubectl\` makes by increasing the verbosity:
    * \`kubectl --v=10 get pods\` (or any other command) will show the actual HTTP request URL, headers, and response.
* **Security Requirement:** The \`kube-apiserver\` is the core Kubernetes process exposing functionality. It is typically started as a systemd process and only allows **TLS certificate-based access** for security.
* **The Role of \`kube-proxy\`:** To provide a secure and simple interface for direct API access from a local workstation without having to manage certificates explicitly, you use \`kube-proxy\`. It establishes a secure tunnel to the API server.


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
