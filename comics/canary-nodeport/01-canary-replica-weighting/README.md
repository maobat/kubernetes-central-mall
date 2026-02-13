<img src="lab04-canary-nodeport.png"
     alt="lab04 - Canary Release using NodePort and Replica Weighting"
     width="35%" />

# 🕵️ The Canary Replica Weighting Mystery

This comic explains:

- How NodePort can be used for canary traffic distribution
- Why replica count affects traffic proportionally
- The difference between **implicit weighting** vs **Gateway API weighting**
- Why this is a **workaround** rather than a feature

📌 Read this if:
- You are working on **LAB 04**
- You want a quick mental model for canary deployments using replicas
- You want to understand **traffic intent vs traffic capacity** 😄

🔗 References:
- Docs → `docs/md-resources/advanced-traffic-splitting.md`
- Lab → `labs/deploying/lab04-canary-nodeport`
