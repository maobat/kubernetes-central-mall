### 3.5 Lab 6.3.3.2: Advanced Traffic Splitting
Why upgrade to Gateway API for Canary testing? Because **"Weighting"** (e.g., a 90/10 split) is a native feature of the signage, not a "hack" or a special instruction.

**The "Shop Owner" defines the 90/10 split in the** `HTTPRoute`:
```YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: canary-route
spec:
  parentRefs: [{ name: oklahoma-entrance }]
  rules:
  - backendRefs:
    - { name: stable-nginx, weight: 90 }  # 90% to Old Reliable
    - { name: canary-nginx, weight: 10 }  # 10% to the New Canary
```
**Verification:**
```Bash
# Get the Smart Hub IP
kubectl get gtw
# Test the split (The Host Header trick remains king!)
curl -H "Host: myapp.info" <GATEWAY_IP>
```
Since we have the oklahoma wing of the mall ready with our securepod (`Task 15`), let's apply this new **Gateway API** logic to it. This will transition us from a simple internal pod to a professionally routed "Storefront."
