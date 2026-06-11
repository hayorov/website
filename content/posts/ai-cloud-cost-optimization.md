+++
title = "AI Is Taking Over the Boring Half of FinOps"
date = "2026-02-13"
description = "Where AI-driven cloud cost optimization actually helps — anomaly detection, forecasting, rightsizing — and where you should keep your hands on the wheel."
tags = ["cloud", "finops", "ai", "cost-optimization"]
+++

> 💰 **Topic:** AI in cloud cost management
> 🎯 **Short version:** let the machines do the watching, forecasting, and rightsizing — keep the judgment calls for yourself

I've watched cloud bills spiral more times than I can count. It always starts innocently: a team provisions generously "just for now", a few experiments never get torn down, nobody touches the commitment plans because forecasting feels like gambling. Six months later a third of the bill is pure waste, and someone gets handed "look into costs" as a side quest next to their actual job.

The classic FinOps answer is process — tagging discipline, weekly reviews, dashboards. It works, sort of. But it's reactive by nature: you spend hours investigating a spike that already happened, fix it, and wait for the next one. Meanwhile the footprint keeps growing — thousands of instances, Kubernetes clusters, serverless, storage tiers, and now GPU fleets for AI workloads, each with its own pricing model. No human reviews their way through that weekly.

This is exactly the kind of problem AI tooling is good at. Not the strategy — the volume.

---

## 🔍 The problems that keep repeating

Across teams I've seen, the waste comes from the same handful of places:

- **Sizing for peak, running 24/7.** Actual utilization averages 20–30%, but nobody wants to be the one who under-provisioned.
- **Commitments left on the table.** Reserved Instances and Savings Plans need a usage forecast someone actually trusts. Usually nobody does, so everything runs on-demand.
- **Anomalies nobody catches.** A misconfigured autoscaler can burn thousands before the bill arrives. By then it's archaeology, not incident response.
- **Pricing complexity.** AWS alone has hundreds of instance types across purchase options and regions. Tracking the optimal combination by hand is not a job, it's a punishment.

GPU workloads make all of this worse. Training instances cost serious money per hour, and the failure modes are mundane: a notebook left running overnight, an inference cluster sized for traffic that never came.

---

## 🛠️ What AI tooling actually does well

**Anomaly detection.** Models learn your baseline — daily cycles, weekly patterns, seasonality — and flag deviations in minutes instead of at month-end. The autoscaling group that spun up 500 instances by mistake becomes an alert today, not a forensic exercise in three weeks.

**Forecasting.** Instead of extrapolating last month's number linearly, decent models account for growth patterns and planned changes. It won't be perfect, but it's good enough to have a real budgeting conversation before migrating a workload or kicking off a big training run, not after.

**Autonomous rightsizing.** This is where the actual savings live. Recommendation reports are where good intentions go to die — engineers are busy, and downsizing someone else's instance is nobody's favorite ticket. Platforms that execute changes themselves (with dependency awareness, staged rollouts, and rollback) close the loop that humans chronically don't. On Kubernetes that means adjusting requests and limits, bin-packing pods, and scaling node groups without anyone filing anything.

**Commitment management.** AI is genuinely better than humans at the buy-too-many vs. buy-too-few dance. It watches steady-state usage and keeps coverage high as the infrastructure shifts. This was always a spreadsheet job nobody wanted; now it doesn't have to be one.

---

## 🧰 The tools

The space matured fast. A few names worth knowing: **Sedai** for fully autonomous optimization (their Palo Alto Networks case study claims $3.5M saved — vendor numbers, but directionally believable), **Cast AI** for Kubernetes and especially GPU/spot orchestration, **nOps** if you're AWS-and-EKS-heavy, **CloudZero** if you care about unit economics — cost per customer, per feature — rather than raw totals, and **Holori** for multi-cloud visibility.

Take every "we cut costs by 70%" number with the usual case-study salt. The common thread that matters: these tools act instead of just reporting. That's the actual generational difference from the old cost dashboards.

---

## 🎯 What I'd actually do

If I were starting this today:

1. **Baseline first.** Cost Explorer, GCP Billing, Azure Cost Management — know your top five cost drivers before buying anything.
2. **Recommendations mode before autonomy.** Let the tool suggest for a few weeks. You'll learn whether you trust it, and your team learns what it's about to start doing on its own.
3. **Spot instances for anything fault-tolerant.** Batch jobs, CI, and — with proper checkpointing — model training. Running experiments on spot GPUs instead of on-demand flagship instances is the single biggest GPU saving available.
4. **Be ruthless about idle AI infrastructure.** Auto-shutdown for notebooks, ephemeral environments for experiments, separate sizing for training vs. inference. Most GPU waste is not exotic; it's stuff left on.
5. **Don't forget storage.** Tiering cold data and deleting orphaned snapshots is unglamorous and routinely worth 20% of the bill.

---

## ⚠️ Where to keep your hands on the wheel

Autonomous cost tooling making changes to production is a real operational decision, not a checkbox. You want audit trails, respect for compliance boundaries, and a human in the loop for workloads with unusual patterns — the AI doesn't know that your weird batch job is load-bearing. And watch the lock-in: pick platforms that work across clouds, or you've just traded one dependency for another.

The direction of travel seems clear to me though. Cloud footprints are getting more complex, not less, and the manual review model stopped scaling a while ago. The teams handing the repetitive half of FinOps to machines now are the ones who'll have the spare attention for the decisions that actually need a human.
