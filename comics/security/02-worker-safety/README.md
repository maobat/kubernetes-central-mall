<img src="lab06-worker-safety.png" alt="Worker Safety and SecurityContext" width="40%" />

# 🦺 Worker Safety: SecurityContext

This comic explains **SecurityContexts & Capabilities** using the *Central Mall* analogy.

In a large mall, some maintenance requires heavy machinery, access to the high-voltage electrical panels, or modifying the building's physical structure. Not just any clerk can do this. Instead, contractors must have special permits to enter secure corridors, and they must agree *not* to use dangerous tools unless strictly necessary.

📌 Read this if:
- You want to understand `SecurityContext` at the Pod and Container level
- You are working with `RunAsUser`, `RunAsGroup`, or `fsGroup`
- You are confused by Linux Capabilities (`add` / `drop`)
- You are exploring `Privileged` access (the master key)

---

## 🎯 What This Comic Explains

- **RunAsUser / RunAsNonRoot:** Ensuring the worker isn't secretly the Mall Manager in disguise (running as root).
- **fsGroup:** Giving the worker the right physical key to unlock a specific storage cabinet.
- **Capabilities (Drop: ALL):** Confiscating the worker's specialized toolbox at the door so they can't tamper with the building's infrastructure.
- **Capabilities (Add: NET_ADMIN):** Granting a specific, limited permit to modify the mall's internal intercom wiring, without giving them the master keys.
- **Privileged:** Giving the worker the literal "Master Key" to the entire mall (very dangerous, usually reserved for core infrastructure like the CNI).

> 🛍️ *Trust, but verify. A clerk selling shoes doesn't need the keys to the boiler room.*

---

## 🧠 CKAD Mental Model

- `SecurityContext` can be defined at the **Pod level** (defaults for all containers) OR the **Container level** (overrides the Pod defaults).
- **UID/GID (User/Group ID):** Controls *who* the process is identity-wise, which determines what files it can read/write.
- **Linux Capabilities:** Granular permissions. Instead of making a container "root" (which can do everything), you drop all capabilities and only add back the precise ones needed (like `NET_BIND_SERVICE` to bind to port 80).

---

## 🔗 References
- Chapter → [Chapter 6: Worker Safety & Conduct](../../../sources/study-guide/ch06-security.md)
- Doc → [Worker Safety and Conduct](../../../docs/md-resources/securitycontext-worker-safety-and-conduct.md)
- Lab → [LAB 01 – Managing Security Settings](../../../labs/security/lab01-serviceaccount-identity/README.md)
