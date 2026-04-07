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

### Part 1: Build and Export Images

1. Build the image from `/opt/course/21/workdir`.
2. Export it as a **Docker archive** to `/opt/course/21/docker/myapp-docker.tar`.
3. Export it as an **OCI archive** to `/opt/course/21/oci/myapp-oci.tar`.
4. Use any name and tag for the image (e.g., `retailco/analytics-api:v1`).

**Solution:**

```bash
# navigate to workdir
cd /opt/course/21/workdir

# build and export as docker tarball
docker buildx build -t retailco/analytics-api:v1 . --output type=docker,dest=/opt/course/21/docker/myapp-docker.tar

# build and export as oci tarball
docker buildx build -t retailco/analytics-api:v1 . --output type=oci,dest=/opt/course/21/oci/myapp-oci.tar
```

---

### Part 2: Verification

#### For Docker tarball:
```bash
cd /opt/course/21/docker
docker load -i myapp-docker.tar
docker images | grep retailco/analytics-api
```

#### For OCI tarball:
```bash
cd /opt/course/21/oci
tar -tf myapp-oci.tar | head
```

---

## 🔗 References
- **Study Guide** → [Chapter 3: Images & Modifications](../../../../sources/study-guide/ch03-pod-design.md)
- **Docs** → [Managing Container Images & Rollouts](../../../../reference/md-resources/managing-container-images-and-rollouts.md)
