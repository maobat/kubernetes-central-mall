# 🧪 LAB 06: The Local Delivery Agent (Ambassador Pattern)

## 🎯 Lab Goal
> **Scenario: The Internal Intercom**
> Create a shop with a main web server and a secondary "Ambassador" container that constantly queries the web server. They must communicate entirely without a Kubernetes [Service](../../../../GLOSSARY.md#service).

Learn how to implement the **Ambassador Pattern**, demonstrating how containers within the same Pod share the exact same network namespace and can communicate via `localhost`.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a large department store (`external-proxy`) operates slightly differently:

* **The Main Counter (App Container):** The primary cash register (`httpd` web server) that handles requests.
* **The Floor Manager (Ambassador Container):** An assistant (`alpine`) who constantly checks if the main counter is working by walking over and asking.
* **The Intercom (Localhost):** Because they are in the exact same shop (Pod), the Floor Manager doesn't need to call the Mall Directory (Kubernetes Service) or dial an external phone number. They just yell across the room: *"Hey localhost, are you there?"*

---

## 🛠️ Step-by-Step Solution

### 1. Generate the Scaffold (Imperative Best Practice)
To save time on the CKAD exam, never write a Pod from scratch. Generate the base YAML for the main container first.

```bash
kubectl run external-proxy --image=httpd --port=80 --dry-run=client -o yaml > proxy-pod.yaml
```

### 2. Manual Surgery (Adding the Ambassador)
Open `proxy-pod.yaml` with your editor (`vim proxy-pod.yaml`). You need to add the second container (the "Floor Manager").

> [!TIP]
> **What to add:**
> 1. Keep the `httpd` container exactly as it was generated.
> 2. Add the `proxy` container underneath it.
> 3. Notice that the `proxy` container uses `curl localhost:80`. It does NOT use a Service name or an IP address!

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: external-proxy
  name: external-proxy
spec:
  containers:
  # 1. The Main Counter
  - name: web
    image: httpd
    ports:
    - containerPort: 80

  # 2. The Floor Manager (Ambassador)
  - name: proxy
    image: alpine
    command: ["sh", "-c"]
    args:
    - |
      while true; do
        wget -q -O - http://localhost:80
        sleep 5
      done
```

### 3. Apply the Configuration
```bash
kubectl apply -f proxy-pod.yaml
```

---

## 🔎 Verification

1. **Check Pod Status:** Ensure both containers start successfully.
   ```bash
   kubectl get pods
   # Wait for READY 2/2
   ```

2. **Verify the Intercom:** Check the logs of the `proxy` container. It should be successfully receiving the default `httpd` "It works!" page every 5 seconds.
   ```bash
   kubectl logs external-proxy -c proxy
   # Output should show the HTML response:
   # <html><body><h1>It works!</h1></body></html>
   ```

---

## 🧠 Key Takeaways

> [!IMPORTANT]
> **Network Sharing in Pods**
> Every container inside a single Pod shares the same Network Namespace. This means they share the same IP address and the same port space. 
> 
> If Container A binds to port 80, Container B can reach it simply by calling `localhost:80`. (However, this also means Container B *cannot* also bind to port 80, or you will get a port conflict!).
> 
> The Ambassador Pattern is heavily used to proxy local connections to external databases or services securely.

> [!TIP]
> **CKAD Best Practice: Robust `wget` Loop**
> In exam environments, internet connection inside Pods might be disabled, preventing package installation (`apk add curl` will fail). Using `wget` (pre-installed in BusyBox and Alpine) is much safer.
> 
> Always use `wget -q -O - http://localhost:80` for loops:
> * `-q` (Quiet) suppresses progress bars, keeping logs clean.
> * `-O -` prints the content directly to the console (`stdout`) instead of saving to a file, preventing the `File exists` error on repeated loops.
> * `http://` ensures compatibility with standard GNU `wget` engines.

---

## 🔗 References
- **Study Guide** → [Chapter 2: Multi-Container Patterns](../../../../sources/study-guide/ch02-multi-container.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
