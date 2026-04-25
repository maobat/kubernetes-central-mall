# 🧪 LAB 06: Buildx Image Export

## Images & Modifications – The Perfect "Mannequin"

---

## 🎯 Lab Goal

Learn how to use **Docker Buildx** to build container images and export them in two formats:
- 📦 **Docker archive** (`docker save` style)
- 📂 **OCI archive** (industry standard layout)

---

## 🤔 Why Buildx?

Standard `docker build` is great for simple local containers, but **Buildx** is the professional tool for modern shipping.

1.  **Multi-Platform Mastery:** Build one image that works on your Mac (M1/M2/M3), your colleague's Linux server, and a cloud provider's ARM instance—all in one command.
2.  **Flexible Exporting:** Unlike standard builds that just save to the local Docker engine, Buildx can export directly to a tarball, an OCI layout, or skip the local engine entirely.
3.  **High Efficiency:** Powered by **BuildKit**, it uses advanced caching and parallel processing, making builds significantly faster.

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

# Create and use a new builder that supports advanced exports (tarballs)
# Note: --driver-opt network=host ensures the builder can share your host's internet 
# connection more reliably (fixing potential DNS/timeout issues).
docker buildx create --name mall-builder --driver-opt network=host --use

# Create a simple Dockerfile using vim
vim Dockerfile

# Paste the following content:
FROM alpine
CMD ["echo", "Hello from Buildx!"]

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

# Build and export as a Docker-formatted tarball
# -t retailco/analytics-api:v1          -> Specifies the image name and version tag
# ./workdir                             -> The "Build Context" (where the Dockerfile and source files are)
# --output type=docker,dest=...        -> Buildx uses a "comma-separated" syntax for outputs:
#                                          - type=docker: the exporter (format)
#                                          - dest=PATH  : where the exporter writes the result
docker buildx build -t retailco/analytics-api:v1 ./workdir --output type=docker,dest=./docker/myapp-docker.tar

# Build and export as an OCI-compliant tarball
# --output type=oci                     -> Tells BuildKit to use the Open Container Initiative (OCI) standard layout
#                                          (More universal and modern than the legacy Docker format)
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

---

## 🛠️ Troubleshooting

### Error: "dial tcp: lookup registry-1.docker.io: i/o timeout"
This means the Buildx container (`mall-builder`) cannot reach the internet to pull the `alpine` image.
**Fix:**
1.  Verify your host has internet access.
2.  Try restarting the builder:
    ```bash
    docker buildx stop mall-builder
    docker buildx rm mall-builder
    docker buildx create --name mall-builder --use
    ```
3.  If you are behind a proxy, you may need to pass proxy environment variables when creating the builder.

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
