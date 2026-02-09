### 3.7 The "Traffic Flow" Verification
This section validates the end-to-end request path by confirming that traffic routed through the Gateway reaches the intended backend services, ensuring that routing rules, weights, and policies behave as expected under real request flow.

---
**1. "Check the Infrastructure:** `get all` won't show the signs! Use specific commands:
```Bash
mk -- get gateway,httproute -n oklahoma
```
---
Ensure **PROGRAMMED** is `True` for the Gateway.

**2. Describe the Route:** Verify the sign is officially accepted by the security guard:
```Bash
mk -- describe httproute oklahoma-sign -n oklahoma
```
<i>Look for `Accepted: True` and `ResolvedRefs: True` in the Status section.</i>

---
**3. The Final Test (Street Access):** If on Minikube, open a new terminal and run **minikube tunnel**. Then:
```Bash
curl -i <GATEWAY_IP>/boutique
```
**Summary of the Oklahoma Setup**
|Component|Resource|Mall Analogy|
|-|-|-|
|**Namespace**|`oklahoma`|The Oklahoma Wing|
|**Identity**|`ServiceAccount: secure`|Employee Badge|
|**Worker**|`Pod: securepod`|The Shop Assistant|
|**Counter**|`Service: secure-service`|The Cashier Desk|
|**Entrance**|`Gateway: oklahoma-entrance`|The VIP Glass Doors|
|**Signage**|`HTTPRoute: oklahoma-sign`|The "Boutique This Way" Sign|


[Back to Documentation](../README.md)
