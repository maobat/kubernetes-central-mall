# 🏭 Challenge 1 — The Container Workshop

The workshop has produced a brand-new boutique image.

Unfortunately, several mistakes occurred before it reached the mall.

Some problems happened during the image build, others during deployment, and one while wiring the Service.

Your mission is to reopen the boutique.

> 📍 **Namespace:** all resources for this challenge live in `mall-workshop`.

```text
Dockerfile
      │
      ▼
Container Image
      │
      ▼
kind Cluster
      │
      ▼
Deployment
      │
      ▼
Service
      │
      ▼
Customers
```

Every step of this chain must be correct before customers can enter the boutique.

---

## 🎯 Learning Objectives

After completing this challenge, you will be able to:

- build a container image with Docker;
- inspect and tag container images;
- load local images into a kind cluster;
- diagnose `ImagePullBackOff`;
- understand the relationship between a container port and a Service `targetPort`;
- verify the complete application path using Kubernetes Services.

---

## 🚀 Start the Challenge

Inject the overnight faults into your cluster:

```bash
./setup.sh
```

This applies the base manifest, then breaks it — removing the approved image from every kind node, swapping in a broken image, and misconfiguring the Service port. Everything described below is what you'll find once this script has run.

---

## 🔥 Operational Fires

Overnight, several contractors made unauthorized changes.

### 🚨 Fire 1 — The Wrong Shipping Label

The Deployment references an invalid image.

The approved image already exists somewhere in the cluster.

Find it and restore the Deployment.

---

### 🚨 Fire 2 — The Wrong Internal Door

The Service forwards customers to port **8080**.

The boutique only listens on port **80**.

Repair the Service.

---

### 🚨 Fire 3 — The Truck Never Reached the Mall

Even after rebuilding the image, the kind cluster cannot see it.

Remember that kind nodes have their own container runtime.

Load the approved image into the cluster.

---

## 🕵️ Inspector's Tip — Docker vs kind

Building an image locally **does not** automatically make it available inside a kind cluster.

```text
docker build
        │
        ▼
Local Docker daemon
        │
        │ kind load docker-image
        ▼
kind node
        │
        ▼
Kubernetes Pod
```

If the image exists only in your local Docker daemon, Kubernetes cannot start the Pod and you'll typically observe:

```text
ImagePullBackOff
```

---

## 🕵️ Inspector's Tip — Service Ports

One of the most common mistakes is confusing the Service port with the container port.

```text
Client
   │
   ▼
Service
port: 80
   │
targetPort: 80
   │
   ▼
Container
containerPort: 80
```

If `targetPort` points to the wrong container port, the Pod may be perfectly healthy while every request times out.

---

## ✅ Expected Architecture

```text
Docker image
central-mall/boutique:v2
          │
          ▼
Deployment
          │
          ▼
1 Ready Pod
          │
          ▼
Service
targetPort: 80
          │
          ▼
Welcome to the Container Workshop!
```

---

## 🛠 Useful Commands

Build the image:

```bash
docker build -t central-mall/boutique:v2 .
```

Load it into kind:

```bash
kind load docker-image central-mall/boutique:v2 --name ckad
```

Inspect the Deployment:

```bash
kubectl describe deploy container-workshop -n mall-workshop
```

Inspect the Service:

```bash
kubectl get svc container-workshop -n mall-workshop
```

Verify the repair:

```bash
./verify.sh
```

---

## 🔄 Restore & Clean Up

To rebuild the approved image, reload it into kind, and recreate the `mall-workshop` namespace from a clean, working state:

```bash
./reset.sh
```

Use this if you want to retry the challenge from scratch, or to confirm what the "approved" state actually looks like before diagnosing the faults.

---

<div align="right">

[next challenge ✨](../03-canary-opening/README.md)

</div>

[Advanced Challenges — index ✨](../../advanced-challenges/README.md)