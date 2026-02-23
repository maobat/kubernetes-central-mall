# 📖 Chapter 3: Images & Modifications
*The Perfect Mannequin & High-Speed Uniform Changes*

In the Central Mall, your "Mannequin" is the **Container Image**. It is the frozen-in-time version of your shop's employee. If you want to change the uniform or give them new tools, you don't dress them while they are standing in the window; you swap the whole mannequin for a new version.

---

## 🎭 3.1 The Mannequin Lifecycle

To get a worker into the mall, they follow a specific path. If any part of this path is broken, the shop window stays empty.

| Action | Mall Analogy | K8s / Docker Concept |
| :--- | :--- | :--- |
| **The Blueprint** | The tailor`s instructions. | **Dockerfile** |
| **The Warehouse** | Where all mannequins are stored. | **Registry** (DockerHub, GCR) |
| **The Uniform Swap** | Swapping the old for the new. | **Rolling Update** |



---

## 🛠️ 3.2 Updating the Store (The Blueprints)

In the CKAD, you often need to update a shop that is already running. You don`t delete the shop; you just tell the manager to use a different mannequin.

### 1. The Quick Uniform Swap (Imperative)
If your "manager-firm" Deployment is using `nginx:1.14` and you want to upgrade to `nginx:1.16`:

///bash
kubectl set image deployment/manager-firm nginx=nginx:1.16
///

### 2. Checking the Change
How do you know the new mannequin is actually in the window and hasn`t fallen over?

///bash
kubectl rollout status deployment/manager-firm
///

### 3. The "Undo" Button (The Rollback)
If the new uniform looks terrible and customers are complaining, you can undo it instantly. The manager brings the old mannequin back from the backroom.

///bash
kubectl rollout undo deployment/manager-firm
///



---

## 📝 3.3 Registry Secrets (The VIP Warehouse Pass)

Sometimes, your mannequins are kept in a **Private Warehouse** (Private Registry). To get them, the Mall Manager needs a special "Key" called an `imagePullSecret`. 

Without this key, the manager will stand at the warehouse door and the Pod will show: `ImagePullBackOff`.

///yaml
apiVersion: v1
kind: Pod
metadata:
  name: private-shop
spec:
  containers:
  - name: clerk
    image: private-repo/secret-nginx:latest
  imagePullSecrets:
  - name: my-warehouse-key
///

---

### 🧰 Study Toolbox

* 🖼️ **Comic:** [The Perfect Mannequin - Image Layers](./../../comics/pod-design/03-image-updates/README.md)
* 🧪 **Lab:** [labs/pod-design/lab03-image-updates/README.md](./../../labs/pod-design/lab03-image-updates/README.md)
* 📄 **Doc:** [Managing Container Images & Rollouts](./../../docs/md-resources/managing-container-images-and-rollouts.md)

---

**Next Step:** Now that our staff is dressed and ready, we need to handle the specialized paperwork. In **Chapter 4**, we look at **Special Permits (CRDs & Operators)** for when the mall needs to do something "non-standard."

**Ready to move on to Chapter 4?**