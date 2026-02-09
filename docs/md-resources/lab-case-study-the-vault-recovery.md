### 6.4.5 Lab Case Study: The Vault Recovery
<i>Detailed post-mortem of a HashiCorp Vault deployment. Covers the transition from '0/1 Ready' (Sealed) to '1/1 Ready' (Unsealed), forcing a 'Zombie' Pod deletion, and recovering from a Calico CNI 'Unauthorized' error without losing data.</i>

This lab demonstrates the resilience of **StatefulSets** and the complexities of **CNI (Networking)** and **Readiness Probes**.

**1. Installation via Helm**

We use Helm to deploy a complex "Prefab" store.
```Bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install my-vault hashicorp/vault --version 0.32.0
```
**2. The Discovery (0/1 READY)**

Even though the Pod is `Running`, it is not `Ready`.
  - **The Reason:** Hashicorp Vault starts in a **Sealed** state. It requires manual intervention to open the "Safe."
  - **The Diagnostic:** `kubectl describe pod my-vault-0` showed the Readiness Probe failing because the vault was uninitialized.

**3. Initialization & Key Management**

We initialize the vault to generate the **Master Keys** and the **Root Token**.
```Bash
kubectl exec -it my-vault-0 -- vault operator init
```
> **CKAD Lesson:** Vault uses Shamir’s Secret Sharing. With a **Threshold of 3**, you must provide 3 **different** keys to unseal it. Using the same key 3 times will result in an error.

**4. The "Zombie" Pod Crisis (CNI Failure)**

During the lab, the Pod became stuck in a **Terminating** state due to a **CNI (Calico) Authorization** error. The network "Security Guards" lost their connection to the API server.

**- The Solution:**
  1. **Force Delete:** `kubectl delete pod my-vault-0 --force --grace-period=0`
  2. **Cluster Reset:** `minikube stop` then `minikube start` to refresh CNI tokens and certificates.

**5. Final State: Persistence in Action**

Despite a force deletion and a full cluster restart, the Vault remained **Initialized**.
  - **Why?** Because it is a **StatefulSet** with a **Persistent Volume Claim (PVC)**. The data in `/vault/data` was un-linked from the old Pod and re-linked to the new one.
  - **Final Step:** Run `vault operator unseal` three times with three different keys.
---
### Summary of Final Status

|Resource|Status|Note|
|--|--|--|
|`pod/my-vault-0`|**1/1 Running**|Readiness probe passed after unsealing.|
|`statefulset.apps/my-vault`|**1/1**|Desired state matches current state.|
|`pvc/data-my-vault-0`|**Bound**|The "Locker" survived the restart.|
---

### 6.4.5 Case Study Analogy: The High-Security Jewelry Store (Vault)
This lab is the ultimate proof of how **StatefulSets** protect your business even when the "Mall" (Cluster) faces a total security breakdown.1. 

**1. The Franchise Opening (Helm)**
Instead of building a store from scratch, we buy a **"High-Security Franchise" (Helm Chart)**. It comes with the walls, the staff, and the heavy safe already designed.
  - **The Command:** `helm install my-vault...`
  - **The Mall Result:** The franchise is set up in spot **#0** of the High-Security Wing.

**2. The "Open" Sign is Off (0/1 READY)**
The lights are on, and the staff is inside (`Running`), but the front door is locked.
  - **The Reason:** The store is Sealed. In a high-end jewelry store, the safe is locked by default. The staff can't sell anything if they can't reach the jewels.
  - **The Management Check:** The Mall Manager (Readiness Probe) knocks on the door every 5 seconds. The staff yells, "We’re here, but the safe is locked!" So, the Manager keeps the "Closed" sign on the shop front.

**3. Setting the Combination (Initialization)** 
You, the owner, arrive to set the master combination. You decide to use a **Multi-Manager System (Shamir’s Secret Sharing)**.
  - **The Setup:** You generate 5 unique keys. To open the safe, **3 different managers** must show up with their specific keys.
  - **The Error:** If one manager tries to use the same key 3 times, the safe stays locked. It requires a "Quorum" (3/5) of unique keys.

**4. The "Zombie" Guard Strike (CNI/Calico Failure)**
Suddenly, the Mall’s **Security Radio System (Calico CNI)** glitches. The guards' badges become "Unauthorized." They can't communicate with Central Management.
  - **The Crisis:** You try to fire the staff and restart (`Delete`), but they are stuck in the doorway (**Terminating**) because they can't get the radio signal to confirm they've left.
  - **The Forceful Solution:** You have to physically drag the staff out (`--force`) and reboot the entire Mall's security system (`minikube stop/start`) to give the guards new, authorized badges.

**5. The "Locker" survived! (Persistence)**
The miracle happens here. Even though you "fired" the staff and the Mall shut down, the **Heavy Safe (Persistent Volume)** was bolted to the floor of the shop.
  - **Why?** Because this is a StatefulSet. Unlike a pop-up kiosk (Deployment), the Jewelry Store has a permanent lease on that specific floor space and that specific safe.
  - **The Result:** When the new staff arrives, the safe is still there. It's still **Initialized** with your combination. You just need your 3 managers to walk in, provide their keys (**Unseal**), and the store finally flips to **1/1 READY**.
---
**The "CKAD Student" Takeaway**
|Mall Event|K8s Technical Concept|
|--|--|
|**Franchise Kit**|**Helm:** Pre-packaged complex apps.|
|**Staff inside, door locked**| **Readiness Probe:** App is live but not functional.|
|**The Heavy Safe**|**Persistent Volume:** Data that lives longer than the Pod.|
|**The Radio Glitch**|**CNI (Calico):** The networking layer that assigns Pod IPs.|
|**Permanent Shop #0**|**StatefulSet:** Guaranteed identity and storage mapping.|


[Back to Documentation](../README.md)
