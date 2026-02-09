### 6.3.3 Implementing Canary Deployments
<img src="image-10.png" alt="Canary Deployment Schema in Kubernetes" height="35%" width="35%" />

<img src="image13.png" alt="The 'Smart Transit Hub'" height="35%" width="35%" />

**Canary Deployment** is a progressive release strategy that minimizes risk by exposing the new version (the "canary") only to a small fraction of traffic. Unlike Blue/Green, which is a binary switch (on/off), Canary is a dimmer, allowing traffic directed to the new version to be gradually increased. The strategy relies on using **a single persistent Service** that selects Pods belonging to **two separate Deployments** (Stable and Canary). Traffic control is managed by modifying the replica counts (`replicas`) for each Deployment.
