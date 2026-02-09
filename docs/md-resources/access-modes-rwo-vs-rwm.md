<h3 id="section-5-4">5.4 Access Modes: RWO vs. RWM (The Key Type)</h3>

Access Modes define how the storage volume can be mounted and used. This is a critical factor in the PV/PVC binding match.

| Mode | Name | Mall Analogy | Implication |
| :--- | :--- | :--- | :--- |
| **RWO** | ReadWriteOnce | **Private Office Key** | Volume can be mounted by **one Node** (Worker's physical host) for read/write access. Prevents simultaneous writes from different hosts. |
| **ROX** | ReadOnlyMany | **Public Library Card** | Volume can be mounted by **many Nodes** for read-only access. |
| **RWM** | ReadWriteMany | **Shared Warehouse Floor Access** | Volume can be mounted by **many Nodes** for read/write access simultaneously. Used for shared filesystems (like NFS). |

The choice of Access Mode is the key difference between single-Pod storage (like the previous RWO examples) and shared storage setups.


[Back to Documentation](../README.md)
