# Capstone Project Solutions

This directory contains the completed YAML manifests to solve the Capstone Project.

To apply a phase, you can run:
```bash
kubectl apply -f phase1-foundation.yaml
kubectl apply -f phase2-workloads.yaml
kubectl apply -f phase3-networking.yaml
```

*Note: Phase 4 (Maintenance) requires modifying the workloads from Phase 2. The final state of the workloads, including the Phase 4 additions (limits, probes, node affinity), is provided in `phase4-maintenance.yaml`.*
