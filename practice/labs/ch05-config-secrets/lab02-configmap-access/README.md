# 🧪 LAB 02: Creating the Breakroom Rules
*ConfigMap Access in Pods*

In the **Central Mall**, before a clerk can read the rules, the Mall Manager must write them down and post them in the breakroom. This lab focuses on the different ways the Manager can create these rules.

---

## 🎯 Lab Objectives
1. Create a **ConfigMap** from a literal string value.
2. Create a **ConfigMap** from an existing file.

> **CKAD Importance:** Creating ConfigMaps rapidly is essential. You must know both the imperative command and how to create them from a file.

---

## 🛠️ Step 1: The Quick Note (From Literal)

Sometimes, the manager just needs to post a quick, single rule. In this case, we need a ConfigMap named `trauerweide` that contains exactly one rule: `tree=trauerweide`.

> **Architect's Tip:** Use the help command (`kubectl create cm -h`) to see examples of how to do this quickly.

```shell
k create cm trauerweide --from-literal tree=trauerweide
```

---

## 🛠️ Step 2: The Full Document (From File)

For more complex rules, the manager writes them down in a document first, and then pins the whole document to the board. 

In this scenario, there is already a file created with rules at `/root/cm.yaml`. Turn this file into a ConfigMap.

```shell
k create -f /root/cm.yaml
```

---

## 🔎 The Inspector's Check (Verification)

Check that both ConfigMaps exist in the cluster and inspect their contents.

```shell
k get cm
k describe cm trauerweide
```

---

[Back to Chapter 05 Index](../../README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
