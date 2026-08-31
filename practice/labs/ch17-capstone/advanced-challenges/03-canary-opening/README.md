# 🐤 Challenge 3 — The Canary Opening

The mall has **two versions of the same boutique**:

- 🏬 **Stable** serves almost every customer.
- 🐤 **Canary** is the new version, exposed to only a small percentage of visitors.

> 📍 **Namespace:** all resources for this challenge live in `mall-canary`.

Customers always enter through **one shared entrance**:

```text
              Customers
                  │
                  ▼
         checkout Service
                  │
        ┌─────────┴─────────┐
        ▼                   ▼
 Stable Pods          Canary Pod
 (4 replicas)         (1 replica)
```

The important idea is that a standard Kubernetes `Service` **does not perform weighted routing**.

Instead, traffic is distributed across **equivalent ready endpoints**.

```text
4 Stable Pods + 1 Canary Pod
            │
            ▼
      5 ready endpoints
            │
            ▼
Approximate traffic

Stable ≈ 4/5 = 80%
Canary ≈ 1/5 = 20%
```

Changing the rollout percentage simply means changing the **number of ready Pods**.

---

## 🔬 Another Angle — Double-Blind Testing

Canary deployment mirrors a **double-blind clinical trial**:

- **The subjects (users) don't know:** real production traffic gets routed to the Canary without customers choosing or being told they're on the new version.
- **The observation stays objective:** you watch real signals — error rate, latency, logs — under actual traffic, not a synthetic test.
- **Exposure is limited:** if the Canary misbehaves, only the sampled slice of users (≈20% in this challenge) was ever exposed, and you can roll back instantly.
- **Success means promotion:** once the Canary clears every check, you scale it up to 100%, the same way a trial declares a treatment effective after a successful run.

---

## 🔥 Operational fires

Overnight, several contractors made unauthorized changes.

### 🚨 Fire 1 — Too many Stable boutiques opened

The Stable Deployment now runs **five** replicas instead of four.

Restore the correct replica count.

---

### 🚨 Fire 2 — The Canary expanded too much

The Canary Deployment now runs **three** replicas instead of one.

Restore the intended rollout ratio.

---

### 🚨 Fire 3 — The shared entrance ignores the Canary

The `checkout` Service now selects **only Stable Pods**.

Customers never reach the Canary version.

Repair the Service selector so it exposes **both Stable and Canary Pods**.

---

## 🕵️ Inspector's Tip — Verifying the Canary

After repairing the architecture, you can perform a quick sanity check by sending multiple requests to the shared Service.

Launch a temporary BusyBox Pod **in the same namespace**:

```bash
kubectl run tester \
  --rm -it \
  --restart=Never \
  --image=busybox:1.36 \
  -n mall-canary \
  -- sh
```

Then generate 100 requests:

```sh
k run test --image=busybox:1.36 --rm --restart=Never -it -n mall-canary -- sh -c 'for i in $(seq 1 100); do wget -qO- checkout; echo; done | sort | uniq -c'
```

Example output:

```text
     81 STABLE boutique
     19 CANARY boutique
```

> **Inspector's Note**
>
> This is only a **sanity check**, not a strict validation.
>
> A standard Kubernetes `Service` load-balances **connections** across all equivalent **ready endpoints**. With **4 Stable Pods** and **1 Canary Pod**, the expected traffic distribution is approximately:
>
> ```text
> Stable: 4/5 ≈ 80%
> Canary: 1/5 ≈ 20%
> ```
>
> Small samples (for example, 30 requests) may produce noticeably different ratios. Larger samples (100+ requests) generally converge closer to the expected distribution.
>
> The short hostname `checkout` works because the test Pod runs in the same namespace (`mall-canary`).
>
> From another namespace, use either:
>
> ```text
> checkout.mall-canary
> ```
>
> or the fully qualified DNS name:
>
> ```text
> checkout.mall-canary.svc.cluster.local
> ```

---

<div style="text-align: right;">

🔒 [next challenge — unlock in Premium ✨](../../../../PREMIUM.md)

</div>

🔒 [Advanced Challenges — index (Premium) ✨](../../../../PREMIUM.md)