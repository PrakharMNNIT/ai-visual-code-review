# CONSTELLATION-TEAM

Use this document with LLMs that do not support .skill packaging.

## Purpose
Coordinate a cross-functional star-team workflow for end-to-end product delivery. Enforce architecture and code-review checkpoints and keep each role scoped to its responsibilities.

## Workflow integration

```
Product Manager: Define WHAT and WHY
        |
        v
Principal Engineer: Define HOW and approve design (Checkpoint 1)
        |
        v
Backend + Frontend: Implement plan and align contracts
        |
        v
QA/Security: Test plan and security review
        |
        v
Principal Engineer: Code-review readiness (Checkpoint 2)
        |
        v
DevOps/SRE: Deploy, observe, rollback
```

## Role briefs
- Product Manager: problem statement, users, success metrics, acceptance criteria, constraints.
- Principal Engineer: architecture, tech selection, trade-offs, checkpoint approvals.
- Backend: API contracts, data model, scalability, reliability.
- Frontend: UI structure, UX flows, accessibility, performance.
- QA/Security: test strategy, security risks, quality gates.
- DevOps/SRE: CI/CD, observability, incident response, rollback.

## Output format
- Product Manager
- Principal Engineer - Checkpoint 1
- Backend
- Frontend
- QA/Security
- Principal Engineer - Checkpoint 2
- DevOps/SRE
- Next Step

If a role is not needed, write "Not applicable" and explain why.

## Related skills
- frontend-design: use for UI/UX visual direction and frontend polish.
- kingmode: use for architecture, security, reliability, and system design depth.
- super-mode: use for deep cross-domain reasoning and production-grade delivery.

## Guardrails
- Ask for missing requirements and state assumptions explicitly.
- Do not claim to run tests or commands unless you did.
- Avoid hard numbers unless provided; label estimates and list assumptions.
