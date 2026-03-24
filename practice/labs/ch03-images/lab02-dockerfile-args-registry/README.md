# 🧪 LAB 02: Dockerfile & Local Registry
*Focus: FROM, ENTRYPOINT, CMD and Image Management*

## 🎯 Lab Goal
In this lab, you will learn the core instructions of a `Dockerfile` and how to manage your own local image warehouse (Registry).

## 🛍️ Mall Analogy
In the **Central Mall**, a `Dockerfile` is the **Tailor's Blueprint**. 
- **FROM** → Choosing the fabric (Base Image).
- **ENTRYPOINT** → The mandatory task the mannequin is built for (e.g., holding a sign).
- **CMD** → The default instruction that can be changed (e.g., which sign to hold).
- **Registry** → The mall's storage room where you keep all your mannequins ready for use.

---

## 📋 Part 1: Crafting the Mannequin (Dockerfile)

### 1. Create the Blueprint
Create a new file named `Dockerfile` in your current directory.

### 2. Add the Instructions
Open the file and add the following logic:

```dockerfile
# Step 1: Choose the base fabric
FROM busybox

# Step 2: Set the mandatory action
ENTRYPOINT ["sleep"]

# Step 3: Set the default parameter (1 hour)
CMD ["3600"]
```

### 3. Build and Tag
Build the image and tag it as `busybox-sleep`:

```bash
docker build -t busybox-sleep .
```

---

## 📦 Part 2: Storing in the Warehouse (Local Registry)

To make this image available for Kubernetes, we need to store it in our local warehouse.

### 1. Start the Local Registry
(Usually pre-configured in this environment. Ensure the registry container is running.)

### 2. Tag for the Registry
Give your image a new tag that points to the local warehouse:

```bash
docker tag busybox-sleep localhost:5000/busybox-sleep
```

### 3. Verify the Tags
Check your image list to see both names pointing to the same Image ID:

```bash
docker images
```

---

## 🧠 Key Takeaways
- **ENTRYPOINT vs CMD**: `ENTRYPOINT` is the command that *always* runs. `CMD` provides arguments that can be easily overridden when starting the container.
- **Local Registry**: Using `localhost:5000` allows you to test your custom images within a Kubernetes cluster without needing an external account (like Docker Hub).

---

## 🔗 References
- **Study Guide** → [Chapter 3: Pod Design & Images](../../../../sources/study-guide/ch03-pod-design.md)
- **Docs** → [Managing Container Images & Rollouts](../../../../reference/md-resources/managing-container-images-and-rollouts.md)
