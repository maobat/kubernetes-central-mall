## 9.0 Sample CKAD Exam Flow
The Final Simulation (CKAD Sample Exam)
The Sample Exam is designed to test your "Muscle Memory." In the real CKAD, you won't have time to look up every command. You need to know which tool to grab from your belt immediately.

## 9.1 The Exam Strategy: "Triage"
Just like a busy Mall Manager during a holiday rush, you must prioritize your tasks:
1. **Fast Wins First:** Tackle simple Pod creations and ConfigMaps first.
2. **The 10-Minute Rule:** If a Troubleshooting task (like a broken Service) takes more than 10 minutes, skip it and come back.
3. **Context is King:** Always check which cluster and namespace you are in using `kubectl config set-context --current --namespace=...`.

## 9.2 Core Competency Checklist
Before starting the sample exam, ensure you can perform these "Reflex Actions":
|Domain|Key Action|Command Reflex|
|-|-|-|
|Storage|Mount an `emptyDir` or `PVC`.|`k run ... --dry-run=client -o yaml` then edit volumes.|
|Deployments|Perform a Rolling Update/Undo.|`k rollout undo deployment/<name>`|
|Networking|Create a Service for a Pod.|`k expose pod <name> --port=80 --target-port=8080`|
|Security|Check permissions.|`k auth can-i create secrets --as system:serviceaccount:default:mysa`|
Troubleshooting|Find why a Pod is failing.|`k get events --sort-by='.lastTimestamp'`|


[Back to Documentation](../README.md)
