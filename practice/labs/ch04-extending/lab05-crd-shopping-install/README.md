# 🧪 LAB 05: The Nightly Shopping Charter (Beta)

## Architecture – Beta API Extension & Instance Creation

---

## 🎯 Lab Goal

Learn how to install a new **Beta CRD** that the team has been working on and create a specific instance based on it.

---

## 📋 Requirements

The team worked really hard for months on a new **Shopping-Items CRD** which is currently in beta.

1. **Rulebook Update:** Install the CRD from `crd.yaml`.
2. **First Order:** Create a `ShoppingItem` object named `bananas` in the `default` namespace.
3. **Details:** 
   - `dueDate` → "tomorrow"
   - `description` → "buy yellow ones"

---

## 🛠️ Step-by-Step Solution

### 1. Register the Beta Charter
Apply the blueprint that defines the new resource.
```bash
kubectl apply -f crd.yaml
```

### 2. Verify Discovery
```bash
kubectl get crd | grep shopping
```

### 3. Create the Shopping Item
```bash
# Apply the bananas instance
kubectl apply -f bananas.yaml
```
or via imperative command (not recommended for CRDs)
```bash
# 1. Generate a generic skeleton
kubectl run bananas --image=dummy --dry-run=client -o yaml > bananas.yaml
# 2. Edit the file to match the CRD
vi bananas.yaml
```
```yaml
apiVersion: "beta.killercoda.com/v1"
kind: ShoppingItem
metadata:
   name: bananas
spec:
   description: buy yellow ones
   dueDate: tomorrow
```
# 3. Apply the file
kubectl apply -f bananas.yaml
```
---

## 🔎 Verification

1. **Check the Order:**
   ```bash
   kubectl get shopping-item
   kubectl get shopping-item bananas -o yaml
   ```

---

## 🔗 References
- **Comic** → [The Nightly Backup Permit](../../../../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- **Study Guide** → [Chapter 04: Extending](../../../../sources/study-guide/ch04-extending-k8s.md)
