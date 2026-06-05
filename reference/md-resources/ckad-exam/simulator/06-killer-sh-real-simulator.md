# 🏁 CKAD Practice Exam Simulator (Questions Only)

Welcome to the real-simulator mode. This file contains **only the questions** as you would see them on the exam screen. Solutions, fast execution commands, and docs references have been stripped so you can practice under realistic time pressure.

Use [06-killer-sh-simulator.md](./06-killer-sh-simulator.md) to check the solutions and [check-answers-labs.sh](../scripts/check-answers-labs.sh) to grade your cluster state.

> [!NOTE]
> **Practice Environment vs. Real Simulator Contexts:**
> * **In the Real Simulator / Exam:** You work in a multi-cluster, multi-node topology. Questions will prompt you to access specific environments (e.g., `ssh ckad5601` or switch context via `kubectl config use-context ...`).
> * **In Your Local Practice Environment:** You are running on a single local cluster (e.g., Kind or Minikube). **Do not run `ssh ckad5601`** (this host does not exist on your machine). Instead, execute all commands directly on your local terminal and save output files to `/opt/course/...` locally.

---

Question 1
<p class="doc-link-row"><a href="https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces" class="doc-link-copy" target="_blank" rel="noopener noreferrer">Namespaces</a> <a href="https://kubernetes.io/docs/reference/kubectl/quick-reference" class="doc-link-copy" target="_blank" rel="noopener noreferrer">kubectl Quick Reference</a></p>

- [ ] ⚑ Flag this

<p>Solve this question on instance: <code class="copy-on-click">ssh ckad5601</code></p>

<p>The DevOps team would like to get the list of all Namespaces in the cluster.</p>

<p>The list can contain other columns like <code class="copy-on-click">STATUS</code> or <code class="copy-on-click">AGE</code>.</p>

<p>Save the list to <code class="copy-on-click">/opt/course/1/namespaces</code> on <code class="copy-on-click">ckad5601</code>.</p>

---

Question 2
<p class="doc-link-row"><a href="https://kubernetes.io/docs/concepts/workloads/pods" class="doc-link-copy" target="_blank" rel="noopener noreferrer">Pods</a> <a href="https://kubernetes.io/docs/reference/kubectl/quick-reference" class="doc-link-copy" target="_blank" rel="noopener noreferrer">kubectl Quick Reference</a></p>

- [ ] ⚑ Flag this

<p>Solve this question on instance: <code class="copy-on-click">ssh ckad5601</code></p>

<p>Create a single Pod of image <code class="copy-on-click">nginx:1.14</code> in Namespace <code class="copy-on-click">default</code>.</p>

<p>The Pod should be named <code class="copy-on-click">pod1</code> and the container should be named <code class="copy-on-click">pod1-container</code>.</p>

<p>Your manager would like to run a command manually on occasion to output the status of that exact Pod.</p>

<p>Please write a command that does this into <code class="copy-on-click">/opt/course/2/pod1-status-command.sh</code> on <code class="copy-on-click">ckad5601</code>.</p>

<p>The command should use <code class="copy-on-click">kubectl</code>.</p>

---

[Back to Documentation](../../README.md)
---
[Mall Directory ✨](../../../../GLOSSARY.md)
