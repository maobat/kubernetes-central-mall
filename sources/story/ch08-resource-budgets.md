# Ch. 8: Resource Budgets: Water and Electricity Limits

The Central Mall is a shared space. It has a limited supply of water, electricity, and air conditioning. If one shop—say, a massive "Gelato Factory"—starts using all the electricity for its freezers, the "Bookstore" next door might experience a blackout. To keep the mall running smoothly, the Owner enforces **Resource Budgets**.

## The Guaranteed Minimum (Requests)

When a new shop owner signs a lease, they specify the **Requests**. This is the "Guaranteed Minimum." 

- "I need at least 10 amps of power and 5 gallons of water per hour just to keep the lights on and the floor clean."

The **Management Office (Scheduler)** checks the mall's capacity. If there isn't enough power left on the "Second Floor" (Node) to meet this minimum request, the shop owner isn't allowed to open there. They must wait until a floor with enough capacity is found. Once assigned, that 10 amps of power is "reserved" for that shop—no one else can take it.

## The Circuit Breaker (Limits)

While a shop is guaranteed its minimum, it might sometimes need a burst of power for a special event. However, every shop has a **Circuit Breaker**. This is the **Limit**.

- "You can use up to 20 amps for a short time, but if you hit 21, the fuse will blow."

In Kubernetes, this works differently for different resources:
- **Electricity (CPU):** If a shop tries to use more CPU than its limit, the Management Office "throttles" them. The lights dim, and the machinery slows down, but the shop stays open.
- **Water/Space (Memory):** If a shop tries to store more "stuff" (RAM) than its limit, it's like a flood or a structural collapse. The **Security Guard (OOM Killer)** steps in immediately and shuts the shop down (**OOMKilled**) to protect the rest of the mall.

## The Floor-Wide Budget (Quotas)

Sometimes, the Owner wants to limit an entire wing of the mall, regardless of how many shops are in it. This is the **ResourceQuota**.

Imagine the "Local Hobbyist Wing" is given a total budget of 100 amps for the whole floor. If five shops are already using 20 amps each, a sixth shop cannot open, even if they only need 1 amp. The floor's budget is maxed out. This prevents a single department from hogging all the mall's resources.

## The Balanced Mall

By carefully managing **Requests**, **Limits**, and **Quotas**, the Mall Owner ensures that every shop has what it needs to survive, while preventing any single "Resource Hog" from endangering the entire ecosystem. It's a delicate balance that keeps the lights on for everyone.

---

### Resources for this Chapter:
- [Resource Requests, Limits, and Quotas](file:///home/mauro.battello/projects/kubernetes-central-mall/docs/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)

[<< Previous Chapter: Identity & Access](ch07-identity-and-access.md) | [Back to Story Index](../story.md) | [Next Chapter: Launch Strategies >>](ch09-launch-strategies.md)
