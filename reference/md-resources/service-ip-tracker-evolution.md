## 4.0 The Evolution of the Service IP Tracker


Both <b>Endpoints</b> and <b>EndpointSlices</b> represent the "Guest List" (the people currently inside), but they represent how that list is physically written and managed.

| CONCEPT | RESOURCE | MALL ANALOGY | FUNCTION & SCALABILITY |
| :--- | :--- | :--- | :--- |
| Legacy IP List | `Endpoints` | The Original, Single, HUGE Map | One long piece of paper listing every single employee. If one person joins, you have to rewrite the entire scroll. |
| Modern IPs | `EndpointSlice` | The Modern Digital Directory | The list is broken into small pages (Slices). If a person joins, you only update one small page, not the whole directory. |

In the mall, the **Service** is the "Front Door." It never moves. The **EndpointSlice** is the "Guest List" of who is currently working inside.

### Service vs. EndpointSlice Names
* **The Service (`canary-svc`):** Has a **fixed name** and a **static ClusterIP**. This is what users and other apps connect to.
* **The EndpointSlice (`canary-svc-abc12`):** Has a **generated name**. It is a dynamic helper object that stores the real-time IP addresses of your Pods. Kubernetes uses a label to link it to the Service.

**Diagnostic Commands:**
```bash
# Get the stable "Front Door"
kubectl get svc canary-svc

# Get the dynamic "Guest List" using a label filter
kubectl get endpointslice -l kubernetes.io/service-name=canary-svc
```

[Back to Documentation](../README.md)
