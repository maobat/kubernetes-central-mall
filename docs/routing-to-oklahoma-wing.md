### 3.6 Lab Exercise: Routing to the Oklahoma Wing 

<img src="images/image11.png" alt="Canary Deployment Schema in Kubernetes" height="35%" width="35%" />

We are transforming the `oklahoma` wing from an isolated pod into a professional storefront accessible via the **Gateway API**.

---
**Step 1: Create the Shop Counter (Service)**
The Gateway needs a stable "Counter" to send shoppers to.
```Bash
mk -- expose pod securepod -n oklahoma --port=80 --name=secure-service
```
---
**Step 2: Install the "Rulebooks" (CRDs)**
To use the modern Gateway API, we must add the building codes to the cluster-wide library.

> **Note:** We use the **experimental** version because modern controllers like Nginx Gateway Fabric expect the full rulebook (including GRPCRoutes) to even start.
```Bash
mk -- apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/experimental-install.yaml
```
---
**Step 3: Hire the Guard (Install Controller)**
We use Helm to bring in the **NGINX Gateway Fabric**, which acts as the security team managing the doors.
```Bash
helm install my-nginx oci://ghcr.io/nginxinc/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway
```
---
**Step 4: Verify the Architect (GatewayClass)**
Wait for the Pod in `nginx-gateway` to be `2/2 Running`. Then, confirm the Architect is ready:
```Bash
mk -- get gatewayclass
# Result: NAME: nginx, ACCEPTED: True
```
---
**Step 5: Build the Physical Entrance (Gateway)**
Create `oklahoma-gateway.yaml`. This is the physical door where traffic enters the `oklahoma` wing.
```YAML
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: oklahoma-entrance
  namespace: oklahoma
spec:
  gatewayClassName: nginx 
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    allowedRoutes:
      namespaces:
        from: Same
```
**Apply it:** `mk -- apply -f oklahoma-gateway.yaml -n oklahoma`

---
**Step 6: Hang the Signage (HTTPRoute)**
Create `oklahoma-route.yaml`. 
This sign tells shoppers: "If you want the Boutique, go to the secure-service counter."
```YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: oklahoma-sign
  namespace: oklahoma
spec:
  parentRefs:
  - name: oklahoma-entrance 
  rules:
  - matches:
    - path: { type: PathPrefix, value: /boutique }
    filters:                      # <--- THE FIX: URL Rewrite
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplacePrefixMatch
          replacePrefixMatch: /   # Strips /boutique and sends / to the pod
    backendRefs:
    - name: secure-service
      port: 80
```
**Apply it:** `mk -- apply -f oklahoma-route.yaml -n oklahoma`


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
