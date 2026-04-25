# 🧪 LAB 01: Build Container from Scratch

## Images & Modifications – The Perfect "Mannequin"

---

## 🎯 Lab Goal

Learn how to build a container image from a `Dockerfile`, run it, tag it, and push it to a local registry using Docker or Podman.

---

## 🛍️ Mall Analogy

In the **Central Mall**, your container image is the **Mannequin** – the frozen-in-time version of your shop's employee. 

- **Dockerfile** → The tailor's blueprint/instructions.
- **Image** → The finalized mannequin.
- **Container** → The running instance of an image (manager puts the mannequin in the shop).
- **Registry** → The warehouse where all mannequins are stored.

---

## 📋 Requirements & Step-by-Step

> **Note:** For most situations you can just use the commands `docker` or `podman` interchangeably. Just stick to your choice throughout all steps.

### Part 1: Build and Run a Container

1. Create a new file `/root/Dockerfile` to build a container image from. It should:
   - Use `bash` as base
   - Run `ping killercoda.com`
2. Build the image and tag it as `pinger`.
3. Run the image (create a container) named `my-ping`.

**Solution:**

Create the `/root/Dockerfile`:
```dockerfile
FROM bash
CMD ["ping", "killercoda.com"]
```

Build the image:
```bash
podman build -t pinger .
podman image ls
```

Run the image:
```bash
podman run --name my-ping pinger
```

---

### Part 2: Push Image to Registry

1. Press `Ctrl+c` to exit the running container.
2. Tag the image, which is currently tagged as `pinger`, also as `local-registry:5000/pinger`.
3. Then push the image into the local registry.

**Solution:**

```bash
podman tag pinger local-registry:5000/pinger
podman image ls
podman push local-registry:5000/pinger
```

---

### Part 3: Push Image with Custom Tag to Registry

Without specifying a `:tag`, the default `:latest` will be used. Now we want to use tag `:v1` instead.

1. Tag the image, which is currently tagged as `pinger`, also as `pinger:v1` and `local-registry:5000/pinger:v1`.
2. Then push the image into the local registry.

**Solution:**

```bash
podman tag pinger pinger:v1
podman tag pinger local-registry:5000/pinger:v1
podman image ls
podman push local-registry:5000/pinger:v1
```

---

## 🔗 References
- **Study Guide** → [Chapter 3: Images & Modifications](../../../../sources/study-guide/ch03-pod-design.md)
- **Docs** → [Managing Container Images & Rollouts](../../../../reference/md-resources/managing-container-images-and-rollouts.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
