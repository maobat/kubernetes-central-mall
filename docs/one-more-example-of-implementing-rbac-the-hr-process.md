### 4.6.3 One More Example of Implementing RBAC (The HR Process)
To grant a Pod permission to see other Pods, we follow the HR workflow:

1. **Create the Badge:** `kubectl create sa viewer -n bellevue`
2. **Write the Job Description:** `kubectl create role viewer --verb=get,list --resource=pods -n bellevue`
3. **Issue the Assignment:** `kubectl create rolebinding viewer --serviceaccount=bellevue:viewer --role=viewer -n bellevue`
4. **Give the Badge to the Worker:** `kubectl set serviceaccount deployment viewginx viewer -n bellevue`
