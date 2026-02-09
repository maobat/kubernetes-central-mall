<h2 id="section-5-8-1">5.8.1 Dynamic Binding (Automatic Provisioning)</h2>

This is the process where Kubernetes creates the storage for you, making manual PV files redundant.
  - **PVC Request:** The Request Form asks for a specific **Contract Type** (e.g., `storageClassName: standard`).
  - **PV Action:** The Mall Manager attempts a static match, but finding no perfect pre-built room, the **Logistics Officer** (`StorageClass`) is called. The Logistics Officer **automatically provisions a brand-new, perfect Warehouse Slot (PV)** to exactly match the request's size and access modes.
  - **Why PV YAML is Redundant:** Since the **Logistics Officer** creates the PV resource automatically, you only need to define the **StorageClass** (the rulebook) and the **PVC** (the request). **This is why manually defining PV files makes no sense in this scenario.**
  - **When to use:** When you need a new, dedicated storage resource (like a cloud disk) created just for this PVC. This is the preferred method in modern clusters.