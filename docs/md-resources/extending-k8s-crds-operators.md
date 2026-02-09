<h2 id="section-6-4-0">6.4 Extending K8s: CRDs & Operators</h2>
This section explores the component responsible for managing the Custom Resources defined in the previous section. A <b>Controller</b> is a control loop that constantly monitors the state of your cluster and attempts to make the current state match the desired state. An <b>Operator</b> is a specialized Controller that uses Custom Resources to automate complex application lifecycle management.

### 6.4.1 Using Operators
Operators are a method for packaging, deploying, and managing a Kubernetes application. Operators use CRDs to automate complex operational tasks, acting like "robots" that manage the application's lifecycle, from installation and scaling to backup and recovery, all based on best practices.

### 6.4.2 Calico CNI Operator Demo (Production CR Example)
A practical demonstration of consuming a large, industry-standard Custom Resource (CR) by installing and configuring the Calico CNI Operator. This shows how CRDs are used to manage complex infrastructure components like the Container Network Interface (CNI).
