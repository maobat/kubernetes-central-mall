# 🏆 Lab 17.01 – The Grand Opening: A CKAD Capstone Mission

Welcome to the ultimate test of your Central Mall architectural skills. Everything you've learned leads here.

It is highly recommended that you attempt this mission using a local cluster (like `kind` or `minikube`) so you can test the interactions. If you get stuck, the `solutions/` directory contains the correct manifests and commands for each phase.

---

## 📜 Mission Brief

**Date:** Tonight  
**Location:** Kubernetes Central Mall  
**Role:** Chief Mall Architect  
**Objective:** Open the mall before 9:00 AM tomorrow.  

You have one night to:
- prepare the infrastructure
- secure the mall
- deploy the boutiques
- configure customer traffic
- verify everything is operational

Failure is not an option. Good luck, Architect.

---

## 🏗️ Phase 1: Foundation (Security & Config)
**Goal:** Create the mall's zones, establish security credentials, and load the master pricing configuration.

1. **Namespaces:** Before any construction can begin, city planners divide the land into three operational zones: `mall-system`, `mall-shops`, and `mall-security`. Create these namespaces.
2. **ServiceAccount:** In `mall-shops`, create a ServiceAccount named `cashier`.
3. **RBAC:** Create a Role in `mall-shops` named `shop-manager` that can `get`, `list`, and `watch` pods and services. Bind this Role to the `cashier` ServiceAccount using a RoleBinding named `cashier-shop-manager`.
4. **ConfigMap:** Create a ConfigMap named `mall-prices` in `mall-shops` with the following data:
   - `shoes: "50"`
   - `shirts: "25"`
5. **Secret:** Create a generic Secret named `mall-vault` in `mall-system` containing a key `master-password` with the value `supersecret123`.

### ✅ Verify Phase 1
```bash
kubectl get ns | grep mall-
kubectl get role,rolebinding,sa,cm -n mall-shops
kubectl auth can-i get pods --as=system:serviceaccount:mall-shops:cashier -n mall-shops
```

---

## 🏬 Phase 2: The Shops (Workloads & Storage)
**Goal:** Deploy the primary boutiques and mall security systems.

1. **Storage (PV/PVC):** Create a PersistentVolume of 1Gi named `warehouse-pv` with `accessModes: ReadWriteOnce` and `storageClassName: ""` (using `hostPath` `/mnt/data`). Create a PersistentVolumeClaim named `warehouse-pvc` in `mall-shops` with `accessModes: ReadWriteOnce` and `storageClassName: ""` that requests 500Mi. *(Explicitly setting the storage class to empty ensures the PVC binds directly to your PV, avoiding dynamic provisioner defaults).*
2. **StatefulSet (Boutique):** Create a StatefulSet named `shoes-boutique` in `mall-shops`.
   - Replicas: 2
   - Image: `nginx:alpine`
   - Use the `cashier` ServiceAccount.
   - Set the `serviceName` to `shoes-boutique-svc` (we will create the service in Phase 3).
   - Mount the `mall-prices` ConfigMap into `/etc/config` as files.
   - Mount the `warehouse-pvc` PVC into the **main `nginx` container** at `/var/lib/shoes`.
3. **DaemonSet (Security):** Create a DaemonSet named `security-camera` in `mall-security`.
   - Image: `busybox:1.36`
   - Command: `["sh", "-c", "while true; do echo 'Monitoring mall...'; sleep 10; done"]`
4. **InitContainer:** Add an init container to the `shoes-boutique` StatefulSet that writes "Welcome to the Grand Opening!" to a shared `emptyDir` volume at `/usr/share/nginx/html/index.html`. Make sure this `emptyDir` volume is also mounted in the **main `nginx` container** at `/usr/share/nginx/html`.

### ✅ Verify Phase 2
```bash
kubectl get pv,pvc -n mall-shops
kubectl get sts,ds -A
kubectl exec shoes-boutique-0 -n mall-shops -- ls /etc/config
kubectl exec shoes-boutique-0 -n mall-shops -- cat /usr/share/nginx/html/index.html
```

---

## 🌐 Phase 3: Corridors & Entrances (Networking)
**Goal:** Connect the shops internally and open the grand entrance to the public.

1. **Internal Service:** Create a Headless Service named `shoes-boutique-svc` in `mall-shops` exposing port 80. Select the `shoes-boutique` Pods.
2. **External Service:** Create a ClusterIP Service named `mall-entrance` in `mall-shops` exposing port 80. Select the `shoes-boutique` Pods.
3. **NetworkPolicy:** Create a NetworkPolicy in `mall-shops` named `secure-shops` that applies to **all pods** in the `mall-shops` namespace:
   - Denies all ingress traffic by default.
   - Allows ingress traffic on port 80 only from pods in the `mall-system` namespace.
4. **Ingress:** Create an Ingress resource named `grand-entrance` in `mall-shops` that routes traffic for `mall.example.com` (`pathType: Prefix` on `/`) to port 80 of the `mall-entrance` Service. *(Use a NodePort on the `mall-entrance` Service instead if your cluster does not include an Ingress Controller).*

### ✅ Verify Phase 3
```bash
kubectl get svc,ingress,networkpolicy -n mall-shops
# Test access from approved namespace (SUCCEEDS)
kubectl run test-allowed -n mall-system --rm -it --image=alpine -- wget -qO- --timeout=3 http://mall-entrance.mall-shops.svc.cluster.local
# Test access from unapproved namespace (FAILS)
kubectl run test-denied -n default --rm -it --image=alpine -- wget -qO- --timeout=3 http://mall-entrance.mall-shops.svc.cluster.local
```

---

## 🩺 Phase 4: Launch & Maintenance (Probes & Limits)
**Goal:** Ensure the shops are resilient and don't consume all mall resources.

1. **Resource Limits:** Update the `shoes-boutique` StatefulSet. Give the **main `nginx` container only** requests of `64Mi` memory and `250m` CPU, and limits of `128Mi` memory and `500m` CPU.
2. **Liveness Probe:** Add a liveness probe to the `nginx` container that checks if port 80 is responding (HTTP GET `/`). Set `initialDelaySeconds: 5`, `periodSeconds: 10`, and `failureThreshold: 3`.
3. **Readiness Probe:** Add a readiness probe to the `nginx` container that checks if the `/etc/config/shoes` file exists using an `exec` command (`test -f /etc/config/shoes`). Set `initialDelaySeconds: 5` and `periodSeconds: 5`.
4. **Node Affinity:** Update the `security-camera` DaemonSet to only run on nodes labeled `mall-zone=secure`. Use a strict requirement (`nodeSelectorTerms -> matchExpressions -> mall-zone In [secure]`). *(You will need to label one of your cluster nodes first).*

### ✅ Verify Phase 4
```bash
kubectl get sts shoes-boutique -n mall-shops -o jsonpath='{.spec.template.spec.containers[0].resources}'
kubectl describe pod -n mall-shops shoes-boutique-0 | grep -E "Liveness|Readiness"
kubectl get pods -n mall-security -o wide
```

---

## 🎉 Congratulations!
The Grand Opening is ready! The Central Mall architecture has been fully deployed, secured, and validated. You have proven yourself as a true Kubernetes architect.

...

...

...

...

### 🚨 9:00 AM

The city inspector has arrived for a surprise inspection before the doors open. 
He found six critical problems.

**You may not recreate resources. Fix them.**

## 🚨 Phase 5: The Inspection (Troubleshooting)

*Challenge yourself by introducing these errors with `kubectl edit` and then fixing them under a time limit, or just treat this as a mental exercise for the CKAD exam!*

- **"Who removed the permits?"** During the night shift, someone accidentally removed the RBAC permissions. The `cashier` ServiceAccount is missing.
- **"The doors are jammed!"** A contractor applied the wrong NetworkPolicy, blocking all traffic and preventing the Ingress from working.
- **"These prices are wrong!"** A late-night data entry error means the ConfigMap contains the wrong price for shoes.
- **"Cleanup on aisle 4!"** One of the `shoes-boutique` pods is crashing constantly and stuck in `CrashLoopBackOff`.
- **"Where is the other shop?"** The StatefulSet was manually scaled down and has 1 replica instead of 2.
- **"Cameras are offline!"** The `mall-zone=secure` node label is missing, so the DaemonSet doesn't run.
- **"The warehouse is locked!"** The warehouse team mounted the wrong storage, and the `warehouse-pvc` is in a `Pending` state.

---

## 🏅 Final Scoring
How did you do? Calculate your score based on the phases completed successfully without looking at the solutions!

| Phase | Points |
|-------|--------|
| Foundation | 20 |
| Workloads | 30 |
| Networking | 25 |
| Maintenance | 25 |

**Ranks:**
- **90–100**: Grand Architect 🏆
- **75–89**: Senior Mall Engineer
- **50–74**: Shop Builder
- **<50**: Apprentice

---

### 🌅 10:00 AM

Customers enter the mall.  
Children run toward the toy shop.  
The café opens.  
Security cameras are online.  
Cashiers can access inventory.  
The warehouse is stocked.  

Everything works.

The Mall Director smiles.  
*"Congratulations, Architect. The mall is officially open."*

**You are now ready for the CKAD exam.**
