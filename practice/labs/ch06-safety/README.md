# Chapter 06: Worker Safety - Overview

In this chapter, you will focus on hardening your workloads. You'll learn how to implement security policies that restrict what users and processes can do inside the Mall's shops (Pods).

| Lab Name | Description |
| --- | --- |
| [Lab 01: Worker Safety (SecurityContext)](./lab01-worker-safety/README.md) | Learn how to enforce user IDs, prevent root access, and set read-only filesystems. |
| [Lab 02: Drop Privileges (Capabilities & Escalation)](./lab02-drop-privileges/README.md) | Learn to drop all Linux capabilities by default, reissue only what's needed, and block privilege escalation. |
| [Lab 03: The Seccomp Filter (System Call Restrictions)](./lab03-seccomp-profile/README.md) | Learn to restrict which syscalls a worker can make using `seccompProfile`. |

---
[Mall Directory ✨](../../../GLOSSARY.md)
