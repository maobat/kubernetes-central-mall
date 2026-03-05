<img src="floor-security.png" alt="Floor Security Guard - DaemonSet" width="40%" />

# 💂 The Floor Security Guard: A DaemonSet Story

In the **Central Mall**, some employees are assigned to specific shops, but the **Security Guard** is different. The Mall Owner requires exactly one guard to be stationed on **every single floor** of the mall.

---

## 🛍️ Mall Analogy

- **The Building Floors (Nodes)** → The physical structure of the mall.
- **The Security Guard (Pod)** → The specialized worker who provides a universal service (security, background music, or air filtration).
- **The Hiring Rule (DaemonSet)** → A policy that ensures every active floor *automatically* receives exactly one guard. 
- **Automatic Scaling** → If the mall opens a brand new floor (Node), a new Guard is hired immediately without any manual request. If a floor closes, the guard leaves.

> 💂 *One floor, one guard. No more, no less.*

---

## 🧠 Key Takeaways

- **One Pod Per Node:** A DaemonSet ensures that all (or some) Nodes run a copy of a Pod.
- **Node Management:** As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected.
- **Typical Use Cases:** 
  - Running a cluster storage daemon (e.g., `glusterd`, `ceph`).
  - Running a logs collection daemon on every node (e.g., `fluentd`, `logstash`).
  - Running a node monitoring daemon on every node (e.g., `Prometheus Node Exporter`).
- **CKAD Tip:** If you need a pod on *every* node, use a DaemonSet. If you need it on *specific* nodes, use a `nodeSelector` or `tolerations` within the DaemonSet spec.

---

## 🔗 References
- **Study Guide** → [Chapter 1: Workloads & Contracts](../../../../sources/study-guide/ch01-workloads.md)
- **Lab** → [Floor Security (DaemonSets)](../../../../practice/labs/ch01-workloads/lab03-daemonset-floor-security/README.md)
- **Docs** → [The Cast of Characters](../../../../reference/md-resources/cast-of-characters.md)
