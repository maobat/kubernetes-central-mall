# 🧪 LAB 06: Buildx Image Export

## Images & Modifications – The Perfect "Mannequin"

---

## 🎯 Lab Goal

Learn how to use **Docker Buildx** to build container images and export them in two formats:
- 📦 **Docker archive** (`docker save` style)
- 📂 **OCI archive** (industry standard layout)

---

## 🛍️ Mall Analogy

In the **Central Mall**, your production team (RetailCo) needs to package their Analytics API mannequin and deliver it to different departments that might use different display cases.

- **Docker Archive** → A standard wooden crate for traditional showrooms.
- **OCI Archive** → A modern, universal glass case that fits any gallery in the world.

---

## 📋 Requirements & Step-by-Step

> **Note:** The environment will install the `buildx` plugin during setup. 
> 👉 Please **WAIT 2–3 minutes** for it to finish before starting your build.

### Part 1: Local Setup

Before building, let's create a small workspace and a very simple `Dockerfile`.

```bash
# Create a workdir and output folders
mkdir -p buildx-lab/workdir buildx-lab/docker buildx-lab/oci
cd buildx-lab/workdir

# Create a simple Dockerfile
cat <<EOF > Dockerfile
FROM alpine
CMD ["echo", "Hello from Buildx!"]
EOF

# Move back to lab root
cd ..
```

---

### Part 2: Build and Export Images

1. Build the image from `./workdir`.
2. Export it as a **Docker archive** to `./docker/myapp-docker.tar`.
3. Export it as an **OCI archive** to `./oci/myapp-oci.tar`.
4. Use any name and tag for the image (e.g., `retailco/analytics-api:v1`).

**Solution:**

```bash
# Ensure you are in buildx-lab directory
cd buildx-lab

# build and export as docker tarball
docker buildx build -t retailco/analytics-api:v1 ./workdir --output type=docker,dest=./docker/myapp-docker.tar

# build and export as oci tarball
docker buildx build -t retailco/analytics-api:v1 ./workdir --output type=oci,dest=./oci/myapp-oci.tar
```

---

### Part 3: Verification

#### For Docker tarball:
```bash
docker load -i ./docker/myapp-docker.tar
docker images | grep retailco/analytics-api
```

#### For OCI tarball:
```bash
tar -tf ./oci/myapp-oci.tar | head
```

---

## 🔗 References
- **Study Guide** → [Chapter 3: Images & Modifications](../../../../sources/study-guide/ch03-pod-design.md)
- **Docs** → [Managing Container Images & Rollouts](../../../../reference/md-resources/managing-container-images-and-rollouts.md)
