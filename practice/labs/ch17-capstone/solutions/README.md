# Capstone Project Solutions

These manifests represent the expected final state for each phase.

```bash
kubectl apply -f phase1-foundation.yaml
kubectl apply -f phase2-workloads.yaml
kubectl apply -f phase3-networking.yaml
kubectl apply -f phase4-maintenance.yaml
```

> Phase 4 replaces the Phase 2 StatefulSet and DaemonSet definitions with their final versions, including resources, probes, and node affinity.
