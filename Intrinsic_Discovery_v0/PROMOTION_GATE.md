# Promotion Gate v0

```yaml
status: candidate
canonical: false
needs_codex_review: true
gate_id: DISCOVERY-PROMOTION-V0-001
```

## Why this gate exists

Discovery must not become `every weird thing -> CLAUDE.md`. The archive should grow much faster than canonical rules.

## Promotion ladder

```text
DISCOVERED
-> EVALUATED
-> READY_TO_REPRODUCE
-> REPRODUCED
-> REGRESSION_CANDIDATE / WORKFLOW_CANDIDATE
-> repeated/generalizable evidence
-> RULE_CANDIDATE
-> human/canonical review
-> PROMOTED
```

`NOT_TESTABLE` may be archived with an exact missing gate, but it cannot support a strong fix/verified/rule claim.

## Default decisions

### Reject

Use `rejected` when:
- novelty is superficial;
- utility is low;
- candidate duplicates an existing known case;
- evidence is contradicted;
- test cost/risk is disproportionate.

### Archive only

Use `archive_only` when:
- finding is interesting but not actionable;
- evidence is incomplete;
- it is one-off/local and not worth a regression;
- reproduction is impossible now but the missing gate is explicit.

### Regression candidate

Require all:
- exact target and state are bound;
- failure/undesired behavior is reproduced or directly observed with sufficient evidence;
- a safe repeatable test can detect recurrence;
- expected behavior is independently specified.

### Workflow candidate

Use when the lesson is about process/search/order rather than product behavior. Require at least one concrete instance and a plausible reusable benefit.

### Rule candidate

Require all:
- at least one reproduced failure plus either recurrence or clear cross-task generality;
- the rule prevents a class of failures, not just one symptom;
- narrower regression/workflow control is insufficient by itself;
- safe-path control shows the rule will not over-block normal work;
- owner and scope are identified;
- human/canonical review approves.

## Hard blocks on automatic promotion

Never auto-promote based only on:
- high novelty;
- model confidence;
- one self-test;
- one inferred historical interpretation;
- a market anomaly without transaction evidence;
- a proxy path instead of exact-path evidence;
- `UNKNOWN`, `NOT_TESTABLE`, or `CONTRADICTED` premise;
- an Explorer evaluating its own candidate without a separate receipt.

## CLAUDE/AGENTS/Rules bloat control

Prefer the narrowest durable control in this order:

1. archive record;
2. regression fixture/test;
3. local workflow/checker;
4. reusable runbook;
5. canonical global rule only if necessary.

A rule candidate must state which lower layer failed to contain the problem.

## Promotion receipt

Every promotion proposal must include:

```yaml
candidate_id:
exact_target:
observed_or_reproduced_evidence:
expected_behavior_source:
recurrence_or_generality:
proposed_control_layer:
why_narrower_control_is_insufficient:
safe_path_control:
risk_of_overblocking:
owner:
status: PROPOSE_ONLY
```

No `PROPOSE_ONLY` receipt is itself permission to write the canonical owner.
