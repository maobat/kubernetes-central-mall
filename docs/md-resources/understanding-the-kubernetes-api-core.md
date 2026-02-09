<h2 id="section-4-2-1">4.2.1 Understanding the Kubernetes API Core</h2>

The Kubernetes API defines which resources exist (Pods, Deployments, Services, etc.) and how to interact with them.

* **Core API and Groups:** Kubernetes uses a highly extensible core API, allowing additional functionality to be organized into separate **API Groups**.
    * This flexibility is used in **Custom Resource Definition (CRD)** to add resources to Kubernetes, often when installing **Operators**.
    * Each API Group can have its own independent version number (e.g., \`apps/v1\`, \`batch/v1\`).
* **Inspecting Resources:** Use the following commands for an overview:
    * \`kubectl api-resources\`: Shows all API resources defined in specific APIs.
    * \`kubectl api-versions\`: Provides a list of all resource and version information currently available in the cluster.


[Back to Documentation](../README.md)
