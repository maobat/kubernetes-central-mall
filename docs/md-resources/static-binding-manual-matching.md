<h2 id="section-5-8-2">5.8.2 Static Binding (Manual Matching)</h2>
    
  - **Prerequisite:** The Cluster Admin has manually built a custom Warehouse Slot (PV) that is waiting.
  - **PVC Request:** The Request Form must explicitly ask for the same **Contract Type** (often `storageClassName: ""`) as the PV.
  - **PV Action:** The Mall Manager must find an existing, manually-built PV that **also** has the exact same contract label and meets the size/access needs. If the labels don't match, the PVC remains `Pending`.
  - **When to use:** When you need to connect your application to a *specific, pre-existing* storage resource (like a local host path or an existing NFS share).
