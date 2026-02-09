## 4.1.5 Lab: Comprehensive Configuration Integration

This lab demonstrates the simultaneous use of a ConfigMap to mount a custom file and a Secret to inject an environment variable into a single Deployment.

**Goal:** Start an Nginx server using a custom "hello world" page from a ConfigMap and a secret password from a Secret.

**Step 1: Create the Source File**
Create a simple file named `index.html` that will serve as the content.
```bash
echo "hello world from ConfigMap" > index.html
```

**Step 2: Create the ConfigMap (for File Content)**
Store the `index.html` file content in a ConfigMap named `nginx-page-cm`.
```bash
kubectl create configmap nginx-page-cm --from-file=index.html
```

**Step 3: Create the Secret (for Environment Variable)**
Store the secret password as a literal value in a Secret named `app-secrets`.
```bash
kubectl create secret generic app-secrets --from-literal=MYPASSWORD=verysecret
```

**Step 4: Create the Deployment Manifest (deployment.yaml)**
This manifest integrates both resources:
* The ConfigMap (`nginx-page-cm`) is mounted as a volume at `/usr/share/nginx/html`.
* The Secret (`app-secrets`) injects the `MYPASSWORD` value as an environment variable.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: config-integrated-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-config-lab
  template:
    metadata:
      labels:
        app: nginx-config-lab
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort: 80
        env:
        - name: MY_SECRET_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secrets # Reference the Secret
              key: MYPASSWORD   # Reference the key inside the Secret
        volumeMounts:
        - name: config-volume
          mountPath: /usr/share/nginx/html # Nginx document root
      volumes:
      - name: config-volume
        configMap:
          name: nginx-page-cm # Reference the ConfigMap
          # Note: Since the ConfigMap was created with --from-file=index.html,
          # its contents will appear as a file named 'index.html' in the volume mount.
```

**Step 5: Apply and Verify**

1.  Apply the Deployment: `kubectl apply -f deployment.yaml`
2.  Verify the environment variable inside the Pod:
    ```bash
    # Get the Pod name first
    POD_NAME=$(kubectl get pod -l app=nginx-config-lab -o jsonpath='{.items[0].metadata.name}')
    kubectl exec $POD_NAME -- printenv | grep MY_SECRET_PASSWORD
    # Expected output: MY_SECRET_PASSWORD=verysecret
    ```
3.  Verify the mounted file content:
    ```bash
    # Use the same POD_NAME variable
    kubectl exec $POD_NAME -- cat /usr/share/nginx/html/index.html
    # Expected output: hello world from ConfigMap
    ```