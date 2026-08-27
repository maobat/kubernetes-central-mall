# 🧭 CKAD Decision Cheat Sheet

Quick "which one should I pick" tables for the choices that come up most often on the exam.

---

## 🧩 Pod vs Container — Field Placement

A common CKAD trap is putting a field at the wrong level of the spec. Some fields only make sense once per **Pod** (e.g. scheduling, restart policy), others are per **Container** (e.g. env vars, probes), and a few — like `securityContext` — exist at both levels and can be overridden by the Container's setting.

| Field | Pod | Container |
| :--- | :---: | :---: |
| serviceAccountName | ✅ | ❌ |
| nodeSelector | ✅ | ❌ |
| affinity | ✅ | ❌ |
| tolerations | ✅ | ❌ |
| restartPolicy | ✅ | ❌ |
| dnsPolicy | ✅ | ❌ |
| imagePullSecrets | ✅ | ❌ |
| volumes | ✅ | ❌ |
| volumeMounts | ❌ | ✅ |
| env | ❌ | ✅ |
| envFrom | ❌ | ✅ |
| resources | ❌ | ✅ |
| ports | ❌ | ✅ |
| probes | ❌ | ✅ |
| lifecycle | ❌ | ✅ |
| command | ❌ | ✅ |
| args | ❌ | ✅ |
| securityContext | ✅ | ✅ |
| runAsUser (inside securityContext) | ✅ | ✅ |
| runAsGroup (inside securityContext) | ✅ | ✅ |
| runAsNonRoot (inside securityContext) | ✅ | ✅ |
| seccompProfile (inside securityContext) | ✅ | ✅ |
| capabilities (inside securityContext) | ❌ | ✅ |
| allowPrivilegeEscalation (inside securityContext) | ❌ | ✅ |
| privileged (inside securityContext) | ❌ | ✅ |
| readOnlyRootFilesystem (inside securityContext) | ❌ | ✅ |
| fsGroup (inside securityContext) | ✅ | ❌ |

---

## 🏗️ Which Workload Controller?

The trap: picking a Deployment when the app actually needs stable identity/storage, or a Job when it should run forever.

| Need | Use | Why |
| :--- | :--- | :--- |
| Stateless app, scalable, no fixed identity | **Deployment** | Default choice — replicas are interchangeable. |
| Stable network identity + stable storage per replica (databases) | **StatefulSet** | Each Pod keeps its ordinal name and its own PVC across restarts. |
| Exactly one Pod per Node (log shippers, monitoring agents) | **DaemonSet** | Automatically scales with the cluster's Node count. |
| Run-to-completion, one-off or parallel batch task | **Job** | Tracks completions; Pods aren't restarted once they succeed. |
| Run-to-completion on a schedule | **CronJob** | Creates a new Job on a cron schedule. |

---

## 🩺 Which Probe?

The trap: using `livenessProbe` when the real problem is startup time, causing endless restart loops.

| Question you're answering | Probe | Effect on failure |
| :--- | :--- | :--- |
| "Is the app still alive, or should it be restarted?" | **livenessProbe** | Kubernetes kills and restarts the container. |
| "Is the app ready to receive traffic right now?" | **readinessProbe** | Pod is pulled out of the Service's Endpoints — no restart. |
| "Has the app finished a slow startup yet?" | **startupProbe** | Blocks liveness/readiness checks until it succeeds once — prevents slow-starting apps from being killed prematurely. |

---

## 💾 Which Volume Type?

The trap: using `emptyDir` expecting data to survive a Pod restart, or reaching for a PVC when a ConfigMap volume would do.

| Need | Use | Survives Pod restart? |
| :--- | :--- | :--- |
| Scratch space shared between containers in the same Pod | **emptyDir** | ❌ — wiped when the Pod is removed. |
| Mount a file/directory from the Node itself | **hostPath** | ✅, but tied to that specific Node. |
| Durable storage that outlives the Pod, provisioned dynamically or statically | **PersistentVolumeClaim** | ✅ — independent lifecycle from the Pod. |
| Inject config files or key/value pairs as files | **configMap volume** | N/A — sourced from the ConfigMap, not Pod state. |
| Inject sensitive files (certs, tokens, passwords) | **secret volume** | N/A — sourced from the Secret, not Pod state. |

---

## 🌐 Which Service Type?

The trap: reaching for `LoadBalancer` in a local/exam cluster where no cloud provider will ever satisfy it, leaving the Service stuck in `<pending>`.

| Need | Use |
| :--- | :--- |
| Internal-only access between Pods/Services in the cluster | **ClusterIP** (default) |
| Expose on a static port on every Node, for external access without a cloud LB | **NodePort** |
| Cloud-provisioned external load balancer | **LoadBalancer** (requires a cloud provider — usually unavailable in local/exam clusters) |
| Map a Service name to an external DNS name, no proxying | **ExternalName** |

---

## 🔐 ConfigMap vs Secret

The trap: putting sensitive data in a ConfigMap because "it's just easier."

| | ConfigMap | Secret |
| :--- | :--- | :--- |
| **Use for** | Non-sensitive config (flags, URLs, feature toggles) | Sensitive data (passwords, tokens, certs) |
| **Encoding** | Plain text | Base64-encoded (**not** encrypted by default) |
| **Consume as** | env, envFrom, volume | env, envFrom, volume |
| **Exam tip** | — | `stringData` lets you write plaintext in the manifest; Kubernetes base64-encodes it for you. |

---

## 🔑 Role vs ClusterRole / RoleBinding vs ClusterRoleBinding

The trap: granting cluster-wide access with a ClusterRole binding when the task only asked for access inside one namespace.

| | Scope | Bound with |
| :--- | :--- | :--- |
| **Role** | Single namespace only | RoleBinding (same namespace) |
| **ClusterRole** | Whole cluster, or reusable across namespaces | ClusterRoleBinding (cluster-wide) **or** RoleBinding (grants it, but scoped to one namespace) |

> A ClusterRole bound via a **RoleBinding** only grants those permissions inside that RoleBinding's namespace — a common way to reuse one ClusterRole across many namespaces without duplicating rules.

---
[Mall Directory ✨](../../GLOSSARY.md)
