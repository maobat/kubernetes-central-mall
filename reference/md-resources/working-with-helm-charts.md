### 6.2 Working with Helm Charts
---
### 6.2.1 Installing the "Store-in-a-Box"
1. Open a Wholesale Account (Add Repo):
```Bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update  # Get the latest catalog prices/versions
```
2. Basic Installation:
```Bash
# Deploys a MySQL store and auto-generates a name (e.g., mysql-1612)
helm install bitnami/mysql --generate-name
```
---
### 6.2.1.1 Troubleshooting Log: The "Broken Store Kit" Case
Sometimes the prefabricated kit arrives with missing parts or wrong instructions. Here is how we fixed a "Broken MySQL" installation.
|STEP|SYMPTOM|ROOT CAUSE|THE FIX (MALL ANALOGY)|
|--|--|--|--|
|**1. Image Error**|`ImagePullBackOff`|Outdated image path in the blueprint.|**Wrong Supplier**: Tell the workers to get the "Legacy" version of the recipe.|
|**2. Rate Limit**|`ImagePullBackOff`|Docker Hub blocked anonymous requests.|**ID Required**: Give the worker a "Secret Key" to prove they are a registered member.|
|**3. Permissions**|`CrashLoopBackOff`|Container couldn't write to the storage.|**Locked Cabinet**: Use `fsGroup: 1001` to give the worker the keys to the storage warehouse.|

**The "Master Fix" Command:**To fix all these at once, we **Upgrade** the release:
```Bash
helm upgrade <RELEASE_NAME> bitnami/mysql \
  --set image.repository=bitnamilegacy/mysql \
  --set primary.podSecurityContext.fsGroup=1001 \
  --reuse-values
```
---
### 6.2.1.2 The Great Customization Debate: Helm vs. Kustomize
In the mall, you have two ways to build a customized store:
|FEATURE|6.2.2 HELM (The Factory Order)|6.3.1 KUSTOMIZE (The Blueprint Overlay)|
|--|--|--|
|**Philosophy**|**Templating:** The blueprint has "blanks" like `{{ color }}`. You fill them in at the factory.|**Patching:** The blueprint is a solid "Base." You lay a transparent sheet over it and draw changes.|
|**Logic**|You change variables in a `values.yaml` file.|You apply "Overlays" (Dev, Prod) in a `kustomization.yaml`.|
|**Analogy**|**Buying a Prefab Kit:** You order a store and tell the factory "I want 5 windows instead of 2.|**"The Architect's Trace Paper:** You take the standard "Base" plan and draw a red "X" over the parts you want to change.|
---
### 6.2.2 Customizing Before Installing
A Helm Chart uses templates to which specific values are applied. These values are primarily stored in the \`values.yaml\` file within the Chart.

**View Default Values:**
To see the default configuration values of a specific Chart, without downloading it:
```bash
helm show values bitnami/nginx
```

**Download and Edit the Chart:**
1. Use \`helm pull\` to fetch a local copy of the Chart (as a \`.tgz\` file):
```bash
helm pull bitnami/nginx
```
2. Extract and edit the \`values.yaml\` file:
```bash
tar xvf nginx-xxxx.tgz
vim nginx/values.yaml # Edit the desired values
```

**Installation with Custom Values:**
Install the local Chart, specifying the modified \`values.yaml\` file using the \`-f\` option:
```bash
helm install -f nginx/values.yaml my-nginx ./nginx/

# (Optional: helm template --debug nginx renders the final YAML output without actually installing it.)
```
---
**Useful "Mall Inspection" Commands**
  - `helm list`: See all open "Prefab" stores in the mall.
  - `helm status [NAME]`: Read the "Manual" for a specific store (shows passwords/URLs).
  - `helm show chart bitnami/mysql`: Displays only the basic metadata of the Chart (Chart.yaml).
  - `helm show all bitnami/mysql`: See the entire blueprint before buying.
  - `helm template --debug`: **"The X-Ray"**, shows the generated YAML without actually building anything.


[Back to Documentation](../README.md)
