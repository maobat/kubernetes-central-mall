# Ch. 5: ConfigMaps & Secrets: The Price List and the Vault Combination

Running a shop in the Central Mall requires more than just staff and a storefront. You need information. Some of that information is public and changes frequently, like the **Price List**. Other information is highly sensitive and must be kept under lock and key, like the **Vault Combination**.

## The Price List (ConfigMaps)

Imagine a Coffee Shop in the mall. Every day, the prices of beans and milk might change. If the shop owner hard-coded these prices onto the menu boards, they would have to hire a painter to redo the signs every morning. 

Instead, the Owner uses a **Public Bulletin Board**. This is the **ConfigMap**.

1. The Owner writes the current prices on a sheet of paper.
2. They hand it to the **Management Office (API Server)**, which pins it to the mall's digital bulletin board (stored in the Ledger).
3. When the **Worker (Pod)** arrives for their shift, they "mount" a copy of that Price List directly onto their desk. 

Now, if the price of a Latte changes, the Owner just updates the Bulletin Board. The next time the Worker look at the list, they see the new price without ever having to leave their post or be "rehired."

## The Vault Combination (Secrets)

Now, consider the shop's safe. It contains the daily earnings and the key to the back door. The combination to this safe is not something you'd pin to a public bulletin board.

For this, the Mall provides the **Secure Locked Box**. This is the **Secret**.

Secrets work just like ConfigMaps, but with extra layers of caution:
- **The Box is Opaque:** To a casual observer walking by the Management Office, the content of the Secret is obscured (Base64 encoded). 
- **Restricted Access:** Only workers with the correct clearance (RBAC) can even see that the box exists.
- **Memory-Only Handling:** In the Central Mall, Secrets aren't usually stored on the shop's dusty shelves. They are kept in a special "quick-access drawer" (tmpfs/memory) that disappears as soon as the shop closes.

## Decoupling: The Magic of the Desk

The beauty of ConfigMaps and Secrets is that the **Worker** doesn't need to know *where* the information came from. They just know that when they sit at their desk, the "Price List" is in the left drawer and the "Vault Combination" is in the right drawer.

Whether those drawers are filled with **Environment Variables** (loose papers) or **Mounted Volumes** (a bound folder), the worker's job remains the same. This decoupling allows the Mall Owner to change the "business logic" (the prices and keys) without ever disrupting the "workforce" (the Pods).

---

### 🧰 Study Toolbox

### ⚙️ Configuration (ConfigMaps)
* 🖼️ **Comic:** [The Rulebook & The Uniform](../../comics/configuration/01-configmap/README.md)
* 🧪 **Lab:** [LAB 01 – Configuration: ConfigMaps](../../labs/configuration/lab01-configmaps/README.md)

### 🤫 Security (Secrets)
* 🖼️ **Comic:** [The Secret of the High-Security Vault](../../comics/secrets/01-secrets-injection/README.md)
* 🧪 **Lab:** [LAB 03 – Using Secrets to Inject Sensitive Configuration](../../labs/security/lab03-secrets-env-injection/README.md)

[<< Previous Chapter: Extending the Mall](ch04-extending-the-mall.md) | [Back to Story Index](../story.md) | [Next Chapter: Worker Safety & Conduct >>](ch06-worker-safety-and-conduct.md)
