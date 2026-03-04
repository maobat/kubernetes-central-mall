# 3.1 Understanding the Traffic Flow (The "Customer Journey")

To see how these characters interact, follow the path of a request during `Section 10.2 - Task 7`:

1. **The GPS (`/etc/hosts`)**: The customer looks up the address of the Mall.

2. **The Front Door (Ingress)**: The customer arrives at the Mall Entrance and asks for `myapp.info`.

3. **The Security Guard (Ingress Controller)**: Checks the **Rulebook (Ingress Resource)** and identifies that the request belongs to the `updates` department.

4. **The Storefront (Service)**: The guard uses the **Internal Intercom (ClusterIP)** to reach the `task7svc` storefront.

5. **The Staff List (EndpointSlice)**: The Service checks the **Guest List** to see which workers (Pods) are currently available.

6. **The Staff (Pod)**: The request is handed to an available worker who serves the "Nginx Welcome Page."


[Back to Documentation](../README.md)
