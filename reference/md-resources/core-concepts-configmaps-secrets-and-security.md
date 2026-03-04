## 4.1.1 Core Concepts: ConfigMaps, Secrets, and Security

ConfigMaps and Secrets are essential for separating application code (portable) from deployment configuration (environment-specific).

| Concept | Kubernetes Resource | Use Case | Analogy |
| :--- | :--- | :--- | :--- |
| **Configuration** | `ConfigMap` | Non-sensitive data like URLs, usernames, log levels, or configuration files. | A public instruction manual or settings document. |
| **Secrets** | `Secret` | Sensitive data like passwords, API keys, or security certificates. | A secured vault or safe deposit box. |

#### Security Principle for Secrets

Secrets are specialized Kubernetes resources designed for storing sensitive data. They are **Base64 encoded**, not encrypted by default, and must be protected by **RBAC** (Role-Based Access Control) and **etcd** (Every Thing Consistently Distributed) encryption. Secrets are vital for allowing Pods to connect securely to other cluster resources or external services.


[Back to Documentation](../README.md)
