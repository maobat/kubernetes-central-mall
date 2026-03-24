# 🧪 LAB 04: Custom Nginx & Docker Hub
*Focus: Image Customization and Public Registries*

## 🎯 Lab Goal
In this lab, you will learn how to personalize an existing image (Nginx) by injecting your own content, and how to share it with the world via **Docker Hub**.

## 🛍️ Mall Analogy
In the **Central Mall**, sometimes a standard mannequin doesn't fit your brand.
- **Customization (COPY)** → Taking a standard mannequin and dressing it in your shop's specific uniform.
- **Public Warehouse (Docker Hub)** → A global distribution center where any shop manager in the world can order your specific mannequin design.

---

## 📋 Part 1: Dressing the Mannequin (Build)

### 1. Prepare the Uniform
Create a file named `index.html` with your custom message. (Already provided in this directory).

### 2. Write the Tailor's Instructions
Create a `Dockerfile` to tell Docker how to merge the base image with your file:
```dockerfile
FROM nginx:latest
COPY ./index.html /usr/share/nginx/html/index.html
```

### 3. Build and Tag
Build the image. Replace `<username>` with your Docker Hub handle:
```bash
docker build -t <username>/nginx-custom:v1 .
```

---

## 📋 Part 2: Sending to the Global Warehouse (Push)

### 1. Authentication
Log in to your Docker Hub account:
```bash
docker login
```

### 2. The Shipment
Push the image to the public registry:
```bash
docker push <username>/nginx-custom:v1
```

---

## 📋 Part 3: Opening the Shop (Deploy)

### 1. Create the Deployment
Deploy your custom image to the cluster:
```bash
kubectl create deploy custom-nginx --image=<username>/nginx-custom:v1
```

### 2. Expose the Storefront
Create a **NodePort** service to make the page accessible:
```bash
kubectl expose deploy custom-nginx --type=NodePort --port=80 --name=nginx-service
```

### 3. Visit the Shop
Find the assigned port:
```bash
kubectl get svc nginx-service
```
Example Output:
```text
NAME            TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
nginx-service   NodePort   10.109.163.113   <none>        80:30583/TCP   8m11s
```

Test the connection from your terminal using `minikube ip`:
```bash
curl http://$(minikube ip):30583
```

---

## 🧠 Key Takeaways
- **Layering**: Your custom image is built ON TOP of the official Nginx image.
- **Public vs Local**: Docker Hub is accessible from anywhere, whereas the local registry (from Lab 02) is only for your cluster.

---

## 🔗 References
- **Study Guide** → [Chapter 3: Pod Design & Images](../../../../sources/study-guide/ch03-pod-design.md)
- **Docs** → [Managing Container Images & Rollouts](../../../../reference/md-resources/managing-container-images-and-rollouts.md)
