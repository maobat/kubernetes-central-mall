# 🧪 LAB 03: The High-Security Vault (Secrets)

## Environment & Configuration – Handling Sensitive Data

---

## 🎯 Lab Goal

This lab demonstrates how to handle **sensitive data** (passwords, tokens) in Kubernetes. You will learn how to:
- Store sensitive data using a **Kubernetes Secret**.
- Inject secret values into a **Deployment** as environment variables.
- Use **Prefixing** to map internal keys to application-specific variables.

> **CKAD Importance:** Very High. Handling sensitive data correctly is a key security requirement for the exam.

---

## 🛍️ Mall Analogy

In the **Central Mall**, some things can't be posted on the breakroom board.

- **The High-Security Vault (Secret)** → A literal safe with a combination. Only authorized staff know how to open it.
- **The Secret Whisper (Env Injection)** → Instead of printing the code, the manager whispers it to the worker exactly when they need it.
- **The Application Requirement** → The MariaDB shop *requires* the vault code to open its doors.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Secret** | A secure storage for sensitive data. |
| **Environment Variable** | Injecting the confidential data into the process. |
| **Prefixing** | Renaming a general code (ROOT) to a specific one (MARIADB_ROOT). |

---

## 📋 Requirements

1. **Create a Secret** named `supersecret`:
   - Key: `PASSWORD` -> Value: `password`
2. **Deploy MariaDB** named `secretlab`:
   - Image: `mariadb`
   - Requirement: Inject the password from the secret as `MARIADB_ROOT_PASSWORD`.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Vault (Secret)
```bash
k create secret generic supersecret --from-literal=PASSWORD=password
```

### 2. Deploy the Shop
```bash
k create deploy secretlab --image=mariadb
```

### 3. The Secret Whisper (Injection)
Use the `set env` command with a prefix to match what MariaDB expects!
```bash
k set env deployment/secretlab --from=secret/supersecret --prefix=MARIADB_ROOT_
```
*Internal result:* `PASSWORD` becomes `MARIADB_ROOT_PASSWORD`.

---

## 🔎 Verification

1. **Check the Badge (Env):**
   ```bash
   k exec deploy/secretlab -- env | grep MARIADB
   # Output: MARIADB_ROOT_PASSWORD=password
   ```

2. **Check Secret Encoding:**
   Remember that secrets are Base64 encoded, not encrypted by default!
   ```bash
   k get secret supersecret -o yaml
   # Notice the value is scrambled (base64).
   ```

---

## 🧠 Key Takeaways

- **Security:** Secrets avoid putting passwords in plain text in your YAML files or container images.
- **Base64:** Secrets are obscured but easy to decode. In a real mall, you'd add encryption.
- **Application Logic:** Many database images *refuse* to start unless you provide a specific environment variable for the root password.
- **CKAD Tip:** `kubectl set env --from=secret/name` is the fastest way to inject all keys from a secret during the exam.

---

## 🔗 References
- **Comic** → [Secrets](../../../../visual-learning/comics/ch05-config-secrets/01-secrets-injection/README.md)
- **Docs** → [Secrets Use Cases](../../../../reference/md-resources/secrets-use-cases-and-application-integration.md)
- **Study Guide** → [Chapter 5: Configuration](../../../../sources/study-guide/ch05-configuration.md)
