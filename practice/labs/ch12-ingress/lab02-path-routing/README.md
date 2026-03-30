# 🧪 LAB 02: The Grand Entrance (Path-Based Routing)

## Services and Networking – Managing Complex Entry Points

---

## 🎯 Lab Goal

Establish a central "Direction Board" (Ingress) for the **World Wing** of the mall. You will first hire the staff (Deployments), give them intercoms (Services), and then set up the main entrance with path-based routing for `europe` and `asia`.

---

## 🛠️ Lab Setup

If your cluster doesn't have the starting staff or the main entrance controller, run these commands first:

```bash
# 1. Create the wing (namespace)
kubectl create ns world

# 2. Hire the staff (create deployments)
kubectl -n world create deployment europe --image=nginx:1.14
kubectl -n world create deployment asia --image=nginx:1.14

# 3. Build the Main Entrance (Ingress Controller) if not present
# (Only run this if 'kubectl get ingressclass' is empty!)

# IF USING MINIKUBE:
# minikube addons enable ingress

# IF USING KIND:
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# FOR OTHER CLUSTERS (GENERIC):
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

> [!TIP]
> **Kind Cluster Tip:** If you're using **Kind**, you must create the cluster with port mappings (80/443) for Ingress to work. See the [Kind Documentation](https://kind.sigs.k8s.io/docs/user/ingress/) for the exact cluster configuration.

---

## 📋 Requirements

The Nginx Ingress Controller is already installed in the mall. Your task is to make the `europe` and `asia` departments accessible from the outside.

1.  **Intercom Setup:** Create **ClusterIP Services** for both existing deployments (`europe` and `asia`) in the `world` namespace.
    -   Target Port: `80`
    -   Service Names: Must match the Deployment names.
2.  **Direction Board (Ingress):** Create an Ingress resource named `world` in the `world` namespace.
    -   Host: `world.universe.mine`
    -   Path 1: `/europe` pointing to the `europe` service.
    -   Path 2: `/asia` pointing to the `asia` service.
    -   Ingress Class: `nginx`
3.  **Advanced Routing (Optional):** Add an annotation to ensure that trailing slashes are handled correctly (rewrite-target).

---

## 🛍️ Mall Analogy

-   **The Direction Board (Ingress Resource)** → The sign at the main entrance that says "Left for Europe, Right for Asia."
-   **The Intercom (Service)** → The internal phone line connecting the entrance to the specific shop.
-   **The Wing (Namespace)** → The "World" section of the mall.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Intercoms (Services)
Expose the existing deployments as ClusterIP services.
```bash
kubectl -n world expose deploy europe --port 80
kubectl -n world expose deploy asia --port 80
```

### 2. Check the Ingress Class
Ensure you know the correct class name for the mall's controller.
```bash
kubectl get ingressclass
# Expected: nginx
```

### 3. Create the Ingress Manifest (`world-ingress.yaml`)

> [!TIP]
> **CKAD Speed-Run (Imperative):** You can generate this manifest in seconds without a template!
> ```bash
> kubectl -n world create ingress world \
>   --rule="world.universe.mine/europe*(/|$)(.*)=europe:80" \
>   --rule="world.universe.mine/asia*(/|$)(.*)=asia:80" \
>   --class=nginx --dry-run=client -o yaml \
>   | kubectl annotate -f - nginx.ingress.kubernetes.io/rewrite-target='/$2' --local -o yaml > world-ingress.yaml
> ```

### 4. Apply the Blueprint
```bash
kubectl apply -f world-ingress.yaml
```

---

## 🧪 Verification

To test the entrance, you need to find the **NodePort** assigned to your Ingress Controller. 

```bash
# 1. Dynamically find the assigned NodePort
NODE_PORT=$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.port==80)].nodePort}')

# 2. Get the IP of a mall node
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

# 3. Test the wings!
echo "Testing Europe wing..."
curl http://$NODE_IP:$NODE_PORT/europe -H "Host: world.universe.mine"

echo -e "\nTesting Asia wing..."
curl http://$NODE_IP:$NODE_PORT/asia -H "Host: world.universe.mine"
```

> [!TIP]
> **Host Header:** Since we are using a custom domain (`world.universe.mine`), we must pass the `-H "Host: ..."` header so the Ingress Controller knows which "Direction Board" to use.

---

## 🔗 References
- **Comic** → [The Grand Entrance](../../../../visual-learning/comics/ch12-ingress/02-the-grand-entrance/README.md)
- **Study Guide** → [Chapter 12: Ingress](../../../../sources/study-guide/ch12-ingress.md)
