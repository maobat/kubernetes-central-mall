# 🧪 LAB 03: Shared Volumes (emptyDir)
*Focus: Inter-container Communication and Shared Log Storage*

## 🎯 Lab Goal
In this lab, you will learn how to use an `emptyDir` volume to share data between two containers in the same Pod. This is a fundamental pattern for sidecar logging and data transformation.

## 🛍️ Mall Analogy
In the **Central Mall**, an `emptyDir` is a **Shared Stockroom** inside a single shop.
- **The Writer (Shopkeeper)** → They keep adding new receipts to a pile in the stockroom.
- **The Reader (Assistant)** → They stand in the stockroom and watch the pile, reading out every new receipt as it arrives.
- **The Stockroom (emptyDir)** → It only exists as long as the shop is open. If the shop closes (Pod is deleted), the stockroom is cleared.

---

## 📋 Requirements

1. **Namespace:** `volumes`.
2. **Pod:** `shared-pod`.
3. **Containers:**
   - `writer`: Continuously appends the current date to `/data/out.log`.
   - `reader`: Tails the `/data/out.log` file.
4. **Volume:** A shared `emptyDir` mounted at `/data` in both containers.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Workspace
```bash
kubectl create namespace volumes
```

### 2. Deploy the Multi-Container Pod
Use the `shared-pod.yaml` file provided in this directory:
```bash
kubectl apply -f shared-pod.yaml
```

### 3. Verify Inter-Container Communication
Check the logs of the **reader** container to see if it's successfully reading the data written by the **writer**:
```bash
kubectl -n volumes logs shared-pod -c reader --tail=10
```

---

## 🧠 Key Takeaways
- **Shared Filesystem:** Containers in the same Pod can share storage easily via volumes.
- **Sidecar Pattern:** The `reader` acts as a sidecar, processing or surfacing data from the primary `writer` container.
- **Ephemeral Storage:** `emptyDir` is temporary; it lives and dies with the Pod.

---

## 🔗 References
- **Study Guide** → [Chapter 2: Multi-Container Patterns](../../../../sources/study-guide/ch02-multi-container.md)
- **Docs** → [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir)
