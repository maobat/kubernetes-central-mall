# Ch. 14: Probes & Health Checks: The Health Inspector

In the Central Mall, a shop that's open but has no employees, or a restaurant that's serving spoiled food, is worse than no shop at all. To protect customers and the mall's reputation, the Mall Owner employs a **Health Inspector**.

## "Are you still alive?" (Liveness Probe)

The Health Inspector walks by every shop and knocks on the door. "Are you still awake in there?" 

If the employee (Pod) is slumped over their desk and doesn't answer, the Inspector doesn't wait. They immediately call the Mall Manager, who fires the unresponsive worker and hires a fresh replacement. 

This is the **Liveness Probe**. It's a simple check to see if the application is still running. If it's "deadlocked" or crashed, Kubernetes restarts the pod to bring it back to life.

## "Are you ready for customers?" (Readiness Probe)

Sometimes, a new shop has just opened, but they're still unpacking boxes and setting up the shelves. They're technically "alive," but they aren't ready to serve anyone yet.

The Health Inspector asks: "Can you take a customer right now?" 
- If the shop says "No, I'm still setting up," the Inspector tells the Receptionists (the Services and Ingress) to stop sending customers there for a while. 
- Once the shop says "I'm ready!", the traffic starts flowing again.

This is the **Readiness Probe**. It ensures that traffic only reaches pods that are fully initialized and capable of handling requests. Without it, customers might walk into an empty shop and leave frustrated.

## "I'm just starting up" (Startup Probe)

For massive department stores that take a very long time to open their heavy shutters, the Mall Owner gives them a "Grace Period." The regular Health Inspector stays away until the store's own manager signals that the initial setup is finished. This is the **Startup Probe**, perfect for slow-loading applications.

---

### Resources for this Chapter:
- [Comic: The Health Inspector](file:///home/mauro.battello/projects/kubernetes-central-mall/comics/observability/01-the-health-inspector/README.md)
- [Example: Healthz Probe Configuration](file:///home/mauro.battello/projects/kubernetes-central-mall/labs/observability/lab01-liveness-probes-health-inspector/healthz_probe.yaml)

[<< Previous Chapter: Network Policies](ch13-network-policies.md) | [Back to Story Index](../story.md) | [Next Chapter: Debugging & Logs >>](ch15-debugging-and-logs.md)
