### 3.2 Diagnostic Cheat Sheet for "The Cast"
If the mall isn't working, use these commands to find the "Character" at fault:

- **Is the Manager working?** `kubectl get deploy`

- **Are the Workers healthy?** `kubectl get pods`

- **Is the Intercom connected to the Staff?** `kubectl get endpointslices`

- **Is the Security Guard following the rules?** `kubectl describe ingress myapp`


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
