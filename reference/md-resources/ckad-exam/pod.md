Pod with Resources
Create a Pod with Resource Requests and Limits
Create a new Namespace limit .

In that Namespace create a Pod named resource-checker of image httpd:alpine .

The container should be named my-container .

It should request 30m CPU and be limited to 300m CPU.

It should request 30Mi memory and be limited to 30Mi memory.


Solution
First we create the Namespace yaml:

k create ns limit
Then we generate a Pod yaml:

k -n limit run resource-checker --image=httpd:alpine -oyaml --dry-run=client > pod.yaml
Next we adjust it to the requirements:

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: resource-checker
  name: resource-checker
  namespace: limit
spec:
  containers:
  - image: httpd:alpine
    name: my-container
    resources:
      requests:
        memory: "30Mi"
        cpu: "30m"
      limits:
        memory: "30Mi"
        cpu: "300m"
  dnsPolicy: ClusterFirst
  restartPolicy: Always