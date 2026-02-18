# 📦 The Warehouse & The Rental Contract

This comic explains:
- How **PersistentVolumes (PV)** represent physical storage
- How **PersistentVolumeClaims (PVC)** act as rental contracts
- How data survives even if the Shop (Pod) disappears

📌 Read this if:
- You are working on **LAB 01 (Storage)**
- You want to understand **Persistence & Volume Mounting**
- You want a quick **mental model** using the mall analogy 😄

🔗 References:
- Docs → [`docs/md-resources/creating-a-persistentvolume.md`](../../../docs/md-resources/creating-a-persistentvolume.md)
- Lab → [`labs/storage/lab01-persistent-volume`](../../../labs/storage/lab01-persistent-volume/README.md)

---

# 📖 Comic Script (Text Version)

*> **Scene 1:** Ideally, the Shop (Pod) has everything it needs on the shelves.*
*> But sometimes, you need **bulk storage** that survives even if the shop closes or moves.*

---

### Frame 1: The Problem with Local Storage
**Manager (K8s):** "Hey Worker! Where are you keeping the sales records?"
**Worker (Pod):** "In my pocket (Container Filesystem)!"
**Manager:** "But what if you go home (Pod Restart)?"
**Worker:** "Then the records disappear forever!"
*(Manager facepalms)* 🤦

---

### Frame 2: The Solution - The Warehouse (PV)
**Facility Manager (Admin):** "I have built a secure **Warehouse Unit (PersistentVolume)** in the basement. It’s physical, it’s real, and it stays there forever."
**Feature:** `Capacity: 1Gi`, `AccessMode: ReadWriteOnce`

---

### Frame 3: The Rental Request (PVC)
**Manager (K8s) to Worker:** "You can't just walk into the warehouse. You need a **Rental Contract (PersistentVolumeClaim)**."
**Worker:** "I claim 500Mi of space!"
*(Worker holds up a ticket: 'Claim: 500Mi')*

---

### Frame 4: The Connection (Binding & Mounting)
**Manager:** "Approved! Here is the key."
*(Manager connects the **Contract (PVC)** to the **Warehouse Unit (PV)**)*.
**Manager:** "Now, I will install a **Freight Elevator (Volume Mount)** directly from your shop to that unit."

*(Worker drops a file down the chute. It lands safely in the warehouse.)*

---

### Frame 5: Persistence
*(The Shop (Pod) catches fire and disappears.)* 🔥
*(New Shop (Pod) appears instantly.)* ✨
**New Worker:** "Where are the records?"
*(Worker opens the Freight Elevator)*
**New Worker:** "They are still here! The Warehouse never moved!"

---

> **Key Takeaway:**
> - **PV**: The physical hard drive/cloud disk (The Warehouse).
> - **PVC**: The ticket to use it (The Contract).
> - **Pod**: Just a temporary user.
