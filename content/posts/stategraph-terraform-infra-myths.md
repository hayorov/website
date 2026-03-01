+++
title = "Stategraph, 'Terraform Is Dead,' and Other Infra Myths That Won't Die"
date = "2026-03-01"
draft = false
description = "Why Stategraph is a solid execution improvement — not a Terraform replacement — and why IaC isn't going anywhere despite what the hype cycle says."
tags = ["terraform", "infrastructure", "iac", "platform-engineering"]
+++

Every few months, the infrastructure community runs the same playbook. A new tool shows up, does something genuinely useful, and within a week the narrative jumps from "this is a nice improvement" to "Terraform is dead, IaC is over, AI will manage your infrastructure now."

The latest iteration involves **Stategraph** — and while the technology is real and the problem it solves is valid, the conversation around it has drifted into territory I've seen too many times to stay quiet about.

## What Problem Is Actually Being Solved?

Terraform's dependency resolution is excellent — within a single state boundary. That's by design. But real-world infrastructure doesn't live in one state file. Once you're operating at scale, you're dealing with:

- Multiple root modules
- Layered environments
- Shared primitives across teams
- Platform vs. product ownership boundaries

This creates **cross-state dependencies** — and that's exactly where the ecosystem has been building workarounds for years:

- **Terragrunt** for orchestration and DRY config
- **Terramate** for code generation and orchestration
- **CI-driven DAGs** for sequencing applies
- Countless homegrown runners held together with scripts and prayers

None of this happened because Terraform *failed*. It happened because infrastructure isn't deployed as one atomic unit, and it never will be.

Stategraph addresses this gap head-on: it builds a **dependency graph across otherwise isolated execution units**. The result is a unified planning surface, better blast radius awareness, and fewer "apply → discover breakage → re-plan" loops.

That's useful. It removes friction I deal with regularly.

But let's call it what it is: **an execution intelligence layer** — not a replacement for Terraform's model.

## The "Single State Is Broken" Narrative Is Overblown

There's a growing tendency to frame Terraform's state isolation as a design flaw. I see this argument a lot, and it misses the point.

State boundaries exist because they enable:

- **Failure containment** — a bad apply doesn't cascade across your entire estate
- **Deploy independence** — teams ship without waiting on each other
- **Ownership scoping** — clear lines between platform and product
- **Security isolation** — least privilege at the state level

In enterprise environments — especially regulated ones like those I've worked in across APAC — fragmentation of state is **intentional**. You don't want one global graph. You want platform domains, product domains, environment separation, and lifecycle autonomy.

The orchestration complexity we see today isn't caused by Terraform being "too simple." It's caused by **organizational structure**. Conway's Law applies to infrastructure just as much as it applies to software.

Stategraph helps you reason across that structure. It doesn't eliminate the need for it.

## This Is the Kind of Capability Terraform Could Absorb

Technically, nothing about Stategraph is philosophically incompatible with Terraform. It's still dependency resolution, graph execution, and change planning — just extended across boundaries.

In another timeline, this might have simply shipped as:

```bash
terraform plan --global
```

Instead of being positioned as a paradigm shift.

Which is why framing it as a replacement feels more like ecosystem storytelling than an actual architectural shift. Good improvements don't need to be revolutions to matter.

## The AI Layer: IaC Is Not Going Away

Here's the twist that keeps getting bundled into these conversations: **"AI will replace IaC anyway."**

I've written about [AI-driven cloud cost optimization]({{< ref "/posts/ai-cloud-cost-optimization" >}}) and how AI is genuinely changing operational workflows. But the assumption that AI will replace IaC confuses the problem space.

The hard part of infrastructure was never writing HCL or YAML. It's:

- **Governance** — who can change what, and under what conditions
- **Determinism** — knowing exactly what will happen before you apply
- **Auditability** — proving to regulators what changed, when, and why
- **Blast radius control** — limiting the impact of any single change
- **Lifecycle ownership** — clear accountability across teams

AI can accelerate authoring. It can help compose intent. It can suggest configurations and catch misconfigurations before they ship. I use AI tooling daily and it genuinely speeds things up.

But it doesn't remove the need for:

- ✅ Versioned change tracked in git
- ✅ Reviewable plans before execution
- ✅ Controlled, deterministic execution
- ✅ Scoped ownership with clear boundaries

If anything, AI **increases** the need for explicit declarative control. Because now changes can be produced faster than ever — and speed without guardrails is how you get outages at 2 AM.

**IaC becomes the safety system. Not the bottleneck.**

## Where Stategraph Actually Adds Value

Credit where it's due — there are real improvements here:

- **Better impact visibility** across states before you apply
- **Reduced orchestration duplication** — less glue code, fewer homegrown runners
- **Simplified planning loops** — one surface to understand change impact
- **Clearer change surfaces** — who's affected by what

For platform teams operating large multi-root estates, this matters. It reduces operational friction, improves confidence in deploys, and shortens feedback cycles. That's meaningful progress.

But it doesn't change:

- How infrastructure ownership works at the org level
- Why environments are isolated by design
- How compliance boundaries are enforced
- Why deployments must remain deterministic and auditable

## The Reality

Infrastructure is not just a graph problem. It's a **socio-technical system**.

| Layer | What It Does |
|---|---|
| **Terraform** | Models resources — the building blocks |
| **Orchestration** | Models responsibility — who owns what |
| **Stategraph** | Improves execution awareness — what's connected |

AI may change how we *author* infrastructure. But it won't remove the need for explicit state, deterministic plans, and controlled blast radius. These aren't limitations of old tooling — they're requirements of production operations.

## Final Thought

Stategraph is a solid optimization. It makes multi-state Terraform environments easier to reason about, and that's genuinely valuable for anyone running infrastructure at scale.

But calling it a Terraform replacement — or tying it to the idea that IaC is fading away — stretches the technical reality past where I'm comfortable following.

Infrastructure doesn't disappear into prompts. And good execution improvements don't need to be revolutions to matter.
