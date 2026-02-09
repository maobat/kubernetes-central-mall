#### 6.3.2.1 Lab Deployment Steps: Full Traffic Transition Demo

This sequence demonstrates the full process, from initial Blue setup to the zero-downtime switch and the instant rollback capability, using simulated endpoint output.

<table border="1" cellspacing="0" cellpadding="6">
  <tr>
    <th>Phase</th>
    <th>Objective</th>
    <th>Command Executed</th>
    <th>Endpoint Status (k get endpoints bgnginx)</th>
    <th>Status After Execution</th>
  </tr>

  <tr>
    <td>0. Initial Setup (Blue)</td>
    <td>Establish the current production environment (Blue) and the persistent service.</td>
    <td>
      kubectl create deploy blue-nginx --image=nginx:1.14 --replicas=3<br>
      kubectl expose deploy blue-nginx --port=80 --name=bgnginx
    </td>
    <td>
      10.42.0.1:80<br>
      10.42.0.2:80<br>
      10.42.0.3:80 (Blue)
    </td>
    <td>Service selector → blue-nginx</td>
  </tr>

  <tr>
    <td>I. Prepare Green<br>II. Test Green Privately</td>
    <td>Create the new version (Green) and verify it without exposing it to public traffic.</td>
    <td>
      <b>Deploy Green:</b><br>
      kubectl get deploy blue-nginx -o yaml | sed 's/blue-nginx/green-nginx/g' | sed 's/nginx:1.14/nginx:1.15/g' | kubectl apply -f -<br><br>
      <b>Test Green:</b><br>
      <i>This command is the technical step that creates the isolation mechanism. It creates a Service (likely an internal ClusterIP type) called green-test-svc that points exclusively to the new Green Pods. This is the act of "isolation."<br>
      </i><br>
      kubectl expose deploy green-nginx --port=80 --name=green-test-svc<br>
      <br>
      <i>The actual execution of the verification that confirms or not the new code works as expected.<br>
      Run the test from a running Pod (like a temporary debug container or your CI/CD runner) inside the cluster)</i><br><br>
      curl green-test-svc:80<br>
      (<b>Result:</b> If `curl green-test-svc:80` returns the expected response from NGINX `1.15`, the environment is healthy and ready for promotion.)
    </td>
    <td>
      10.42.0.1:80<br>
      10.42.0.2:80<br>
      10.42.0.3:80 (Still Blue)
    </td>
    <td>Green running + private test svc</td>
  </tr>

  <tr>
    <td>III. Traffic Switch (To Green)</td>
    <td>Instantly redirect all production traffic to the new Green environment.</td>
    <td>
      kubectl patch service bgnginx -p '{"spec":{"selector":{"app":"green-nginx"}}}'
    </td>
    <td>
      10.42.0.5:80<br>
      10.42.0.6:80<br>
      10.42.0.7:80 (Green)
    </td>
    <td>Traffic routed to Green</td>
  </tr>

  <tr>
    <td>IV. Rollback to Blue</td>
    <td>Instantly revert all production traffic back to the known-good Blue environment.</td>
    <td>
      kubectl patch service bgnginx -p '{"spec":{"selector":{"app":"blue-nginx"}}}'
    </td>
    <td>
      10.42.0.1:80<br>
      10.42.0.2:80<br>
      10.42.0.3:80 (Blue)
    </td>
    <td>Instant rollback</td>
  </tr>

  <tr>
    <td>V. Final Cleanup</td>
    <td>Delete the environment that is no longer needed (Green in this rollback scenario).</td>
    <td>
      kubectl delete deploy green-nginx
    </td>
    <td>N/A</td>
    <td>Green removed</td>
  </tr>
</table>

**Endpoint Visualization Key:**
* Blue Pod IPs (v1.14): e.g., 10.42.0.1, .2, .3
* Green Pod IPs (v1.15): e.g., 10.42.0.5, .6, .7

The Endpoint status clearly shows that only the Service's selector patch (Phase III or IV) is needed to redirect all traffic instantaneously, which is the core benefit of the Blue/Green strategy.
