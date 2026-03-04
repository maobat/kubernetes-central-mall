# 🧪 LAB 02: The Side Entrance (NodePort & Multi-Namespace)

## Services and Networking – Cross-Wing Communication

---

## 🎯 Lab Goal

This lab focuses on **Service exposure** and **cross-namespace communication**. You will learn how to expose a shop to the outside world using a **NodePort** and how workers in different "wings" (Namespaces) can still talk to each other using the Full Qualified Domain Name (FQDN).

> **CKAD Importance:** Very High. NodePort is the standard way to expose services in many exam tasks, and multi-namespace connectivity is a frequent troubleshooting topic.

---

## 🛍️ Mall Analogy

We are opening a luxury boutique in a brand-new wing of the mall called **"remote"**.

- **The New Wing (Namespace: remote)** → A separate area with its own staff and rules.
- **The Boutique (Pod: remoteweb)** → The shop itself, hidden deep in the `remote` wing.
- **The Side Entrance (NodePort)** → A literal door on the outside wall of the mall (`port 31999`). Customers on the street can enter here directly without going through the main lobby.
- **The Long Intercom (FQDN)** → If a worker in the `default` wing wants to call the boutique, they can't just dial `remoteweb`. They have to use the full address: `remoteweb.remote.wing.mall`.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **NodePort** | A gate on the exterior wall of the mall. |
| **Namespace** | A distinct wing of the mall. |
| **FQDN** | The full mailing address including the wing name. |

---

## 📋 Requirements

1. **Namespace**: Create a wing named `remote`.
2. **Shop**: Run `remoteweb` (nginx) inside the `remote` namespace.
3. **Entrance**: Expose it on the exterior wall using **NodePort 31999**.
4. **Intercom**: Verify that a worker in the `default` namespace can reach it.

---

## 🛠️ Step-by-Step Solution

### 1. Build the Wing and the Store
```bash
k create ns remote
k run remoteweb --image=nginx -n remote
```

### 2. Install the Side Entrance (NodePort)
```bash
k expose pod remoteweb -n remote --port=80 --type=NodePort --overrides='{"spec":{"ports":[{"port":80,"nodePort":31999}]}}'
```

### 3. Test the Long Intercom (Cross-Namespace)
```bash
# Start a test worker in the DEFAULT wing
k run testpod --image=busybox -- sleep infinity

# Dial the remote wing using FQDN
k exec testpod -- wget -qO- remoteweb.remote.svc.cluster.local
```

---

## 🔎 Verification

1. **Internal Check:**
   ```bash
   k exec testpod -- nslookup remoteweb.remote
   # DNS should resolve to the Service IP in the remote namespace.
   ```

2. **External Check:**
   ```bash
   curl $(minikube ip):31999
   # Should return "Welcome to nginx!" from outside the cluster.
   ```

---

## 🧠 Key Takeaways

- **NodePort Range:** By default, NodePorts must be between **30000-32767**.
- **FQDN Anatomy:** `<service>.<namespace>.svc.cluster.local`. This is how you navigate between wings.
- **Port vs TargetPort vs NodePort:**
  - `port`: Exposed on the Service.
  - `targetPort`: The port the application is listening on.
  - `nodePort`: The port exposed on the physical server.
- **CKAD Tip:** If you forget the FQDN, just remember: `service-name.namespace`. Usually, that's enough for `wget` or `curl` to find the target.

---

## 🔗 References
- **Comic** → [NodePort Traffic Adventure](../../../../visual-learning/comics/ch11-services/02-cross-namespace/README.md)
- **Docs** → [NodePort Service](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport)
- **Study Guide** → [Chapter 11: Services](../../../../sources/study-guide/ch11-services.md)
