### 6.3.5 Understanding Custom Resource Definitions (CRDs)

**CRDs** extend the Kubernetes API by introducing new resource types (e.g., \`Database\`, \`MonitoringAlert\`, or application-specific types like \`MyAppBackup\`). They allow users to define and manage custom objects using the same declarative \`kubectl\` commands as native Kubernetes resources.

**Mall Analogy:**
By default, Mall Management can only issue permits for Stores (Deployments), Pick-up Points (Services), or Standard Licenses (Pods). We want to add a new service: the "Nightly Backup Service" (BackUp), which is not part of the Mall's standard ruleset.
