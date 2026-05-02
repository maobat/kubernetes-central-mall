# 🧪 LAB 03: The Public Courtyard (Allow All Ingress)

## Services and Networking – Network Policies

---

## 🎯 Lab Goal

Create a **NetworkPolicy** that allows all incoming traffic ([Ingress](../../../../GLOSSARY.md#ingress)) to all Pods in a specific namespace.

---

## 🛍️ Mall Analogy

**The Public Courtyard** - A specific area in the mall that is completely open to the public. Unlike other rooms that require security badges, the doors to this courtyard are wide open. Anyone can enter!

---

## 🛠️ Step-by-Step Solution

### 1. Setup the Server and Client
First, let's create a namespace, a server (acting as the Public Courtyard), and a client to test connections.

```shell
# Create a namespace for this lab
kubectl create ns net-open

# Deploy the Server pod (the Public Courtyard)
kubectl run server -n net-open --image=busybox:1.36 --restart=Never --labels=app=server -- \
  sh -c "while true; do nc -l -p 8080; done"

# Expose the server pod as a service
kubectl expose pod server -n net-open --port=8080 --name=server-svc

# Deploy the Client pod
kubectl run client -n net-open --image=busybox:1.36 --restart=Never -- sleep 3600
```

### 2. Apply the "Allow All" Network Policy (`np-0.yaml`)

By default, Kubernetes allows all traffic if no policy exists. However, it's a good practice to explicitly define an "Allow All" policy if your security posture requires strict explicit definitions.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-all-ingress
  namespace: net-open
spec:
  podSelector: {} # Empty means it targets ALL pods in the namespace
  policyTypes:
  - Ingress
  ingress:
  - {} # Empty brackets mean ALL sources
```

Apply the policy:
```shell
kubectl apply -f np-0.yaml
```

### 3. Test Connectivity
Test the connection from the client to the server to prove the courtyard is open.

```shell
# Test connection from client to server
kubectl exec client -n net-open -- nc -vz server-svc 8080
```

> **Breakdown of the Command**
>
> - **nc**: The **Netcat** utility (often the busybox or nmap version).
> - **-v** (Verbose): Tells the tool to explain what it is doing. Without this, a successful connection would return no output (a "silent success").
> - **-z** (Zero-I/O): Tells Netcat to only scan for a listening daemon and then immediately close the connection. It doesn't send any actual data, making it perfect for connection testing.
> - **server-svc**: The DNS name of your Service. CoreDNS inside your cluster resolves this to the Service's ClusterIP.
> - **8080**: The target port.

---

## 🧠 Key Takeaways
- An empty `{}` in the `ingress` `from` block implies allowing all sources.
- An empty `{}` in the `podSelector` targets all pods in the namespace.
- This policy essentially says: "For all Pods in this namespace, allow incoming traffic from anywhere."

---
## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
