# 🧪 LAB 03: The Floor Security Guard (DaemonSet)

## 🎯 Lab Goal
Master the creation and management of **DaemonSets** to ensure a specific workload runs on every single floor (Node) of the mall.

## 🛍️ Mall Analogy
In the **Central Mall**, some employees are assigned to specific shops (Deployments), but the **Security Guards** are different. The Mall Owner requires exactly one guard to be stationed on **every single floor**. If the mall expands and opens a new floor, a new guard is hired immediately. If a floor closes for renovation, the guard leaves.

## 📋 Requirements
1.  Create a namespace called `mall-security`.
2.  Create a DaemonSet named `floor-guard` in that namespace.
3.  Use the image `nginx:alpine`.
4.  Ensure the pod template has the label `app=floor-guard`.
5.  Set a resource request of `10m` CPU and `20Mi` memory for each guard.

## 🛠️ Step-by-Step Solution

1.  **Create the Namespace:**
    ```bash
    k create ns mall-security
    ```

2.  **Generate the DaemonSet YAML:**
    DaemonSets are best created by taking a Deployment template and changing the `kind`.
    ```bash
    k create deployment floor-guard --image=nginx:alpine -n mall-security $do > ds.yaml
    ```

3.  **Edit `ds.yaml`:**
    Modify the `kind` to `DaemonSet` and remove the `replicas` field (since DaemonSets manage their own scaling based on nodes).
    ```yaml
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: floor-guard
      namespace: mall-security
    spec:
      selector:
        matchLabels:
          app: floor-guard
      template:
        metadata:
          labels:
            app: floor-guard
        spec:
          containers:
          - name: nginx
            image: nginx:alpine
            resources:
              requests:
                cpu: 10m
                memory: 20Mi
    ```

4.  **Apply the DaemonSet:**
    ```bash
    kubectl apply -f ds.yaml
    ```

## 🔎 Verification
1.  **Check Pod Distribution:**
    ```bash
    kgetp -n mall-security
    ```
    *You should see one pod for every node in your cluster.*

2.  **Verify the Count:**
    ```bash
    k get ds -n mall-security
    ```

## 🧠 Key Takeaways
- **No Replicas:** You don't specify the number of replicas for a DaemonSet; Kubernetes automatically handles one pod per node.
- **Node Specificity:** If you use `nodeSelector` or `tolerations`, the DaemonSet will only run on the nodes that match those rules.
- **CKAD Tip:** DaemonSets are perfect for logging agents (Fluentd), monitoring agents (Prometheus Exposer), or networking plugins (Calico/Flannel).

## 🔗 References
- **Study Guide** → [Chapter 1: Workloads & Contracts](../../../../sources/study-guide/ch01-workloads.md)
- **Docs** → [DaemonSet Concepts](../../../../reference/md-resources/cast-of-characters.md)
