# Ch. 3: Images & Modifications: Creating the perfect "Mannequin"

Every worker in the Central Mall starts as a **Mannequin**. Before a Shop Clerk (Pod) can start their shift, they need to be "dressed" in the perfect uniform with all the right tools. In the world of tech, this template is the **Container Image**.

## The Master Mold (The Base Image)
When you want to create 10 identical shop clerks, you don't dress them one by one. You create a **Master Mold**. 

In Kubernetes, we usually start with a standard mold—like high-quality "Ubuntu" plastic or a specialized "Nginx" worker template. This is the **Base Image**.

## The Customization (The Dockerfile)
The Central Mall Owner doesn't just want a generic worker; they want a worker who is wearing the mall's official uniform and knows the shop's specific greeting.

The **Dockerfile** is the set of instructions given to the factory:
1. "Start with the 'Nginx' mold."
2. "Add this specific 'Price List' to their pocket."
3. "Paint them in the 'Mall Blue' color."
4. "Tell them to start shouting 'Welcome to the Mall!' as soon as they wake up."

## The Factory (Image Build)
When the instructions are sent to the factory, the factory produces the **Final Image**. This image is like a frozen, perfectly-dressed mannequin. It's unchangeable (immutable). 

## The Warehouse (Container Registry)
Once the mannequins are created, they are stored in a **Warehouse**. This is the **Container Registry** (like Docker Hub or a private mall warehouse). 

When the Mall Manager (Deployment) needs 3 new workers, they simply call the Warehouse and say, "Send over 3 clerks using the 'v1.0-blue-uniform' mannequin."

---

### Why use Mannequins?
By using Images, the mall ensures that every worker is **exactly the same**. No more "It worked for the clerk on the morning shift but not for the one in the afternoon." If they are built from the same mannequin, they will behave exactly the same way.

---

### 🧰 Study Toolbox

### 🏗️ Image Updates & Rollouts
* 🖼️ **Comic:** [The Perfect Mannequin](../../comics/pod-design/03-image-updates/README.md)
* 🧪 **Lab:** [LAB 03 – Image Updates & Rollouts](../../labs/pod-design/lab03-image-updates/README.md)

### 📄 Documentation
* 📖 **Docs:** [CKAD Cheatsheet](../../docs/md-resources/ckad-cheatsheet.md) (Look for 'Build' commands)

[<< Previous Chapter: Multi-container Design Patterns](ch02-multi-container-design-patterns.md) | [Back to Story Index](../story.md) | [Next Chapter: Extending the Mall >>](ch04-extending-the-mall.md)
