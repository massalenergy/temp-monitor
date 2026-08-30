# Discovery Contract v0

```yaml
status: candidate
canonical: false
needs_codex_review: true
contract_id: DISCOVERY-V0-001
```

## Mission

Search for materially different, previously unobserved states/questions/patterns around an existing task without treating novelty as truth or authority.

The system is designed to extend Failure Replay upstream:

```text
normal work
-> discovery
-> evaluation
-> safe reproduction / evidence check
-> regression or archive
-> optional durable rule candidate
```

## Roles and authority

### Explorer

May:
- propose unobserved states, action sequences, market-data gaps, anomalies, conflicts, missing evidence, or alternative hypotheses;
- compare a new candidate against an archive excerpt;
- assign a provisional novelty score with rationale;
- produce structured candidate records.

May not:
- change production data;
- buy/sell anything;
- edit `main` or canonical rules;
- assert a historical reading/fact because it is novel;
- close its own candidate as verified.

### Evaluator

May:
- score novelty, utility, risk, evidence quality, reproducibility, and expected learning value;
- reject low-value novelty;
- nominate a candidate for safe reproduction.

May not:
- promote to canon;
- silently convert missing evidence into a positive finding.

### Reproducer / Verifier

May:
- run or specify bounded tests in sandbox/test/read-only environments;
- record exact inputs, state, actions, outputs, and evidence paths;
- return `REPRODUCED`, `NOT_REPRODUCED`, or `NOT_TESTABLE`.

May not:
- claim success from proxy evidence;
- cross a production, purchase, publication, historical-canon, or destructive-action boundary without separate authority.

### Promoter

May propose one of:
- `discard`;
- `archive_only`;
- `regression_candidate`;
- `workflow_candidate`;
- `rule_candidate`.

May not directly modify canonical rules or protected owners unless a separate canonical gate authorizes it.

## Candidate lifecycle

```text
DISCOVERED
  -> EVALUATED
    -> REJECTED | READY_TO_REPRODUCE
      -> REPRODUCED | NOT_REPRODUCED | NOT_TESTABLE
        -> ARCHIVE_ONLY | REGRESSION_CANDIDATE | WORKFLOW_CANDIDATE | RULE_CANDIDATE
          -> HUMAN/CANONICAL REVIEW
            -> PROMOTED | RETIRED
```

No step may be skipped merely because the same model performs multiple roles in one session. Each role must emit a separate receipt section.

## Mandatory record fields

Every discovery candidate must preserve:

- stable id;
- domain and exact target;
- seed/current task;
- pre-state or evidence context;
- proposed action/question/search;
- observation or expected observation;
- novelty rationale;
- utility rationale;
- risk class;
- evidence state;
- reproduction state;
- promotion state;
- source/session/date.

See `DISCOVERY_RECORD.schema.json`.

## Novelty is not value

Keep at least two independent judgments:

```text
novelty = how different/unseen is this?
utility = would learning this change a decision, prevent failure, reveal market information, or improve the product/process?
```

A high-novelty/low-utility candidate should normally be discarded or archived without further work.

## Evidence states

Use only:

- `OBSERVED`
- `INFERRED`
- `UNKNOWN`
- `NOT_TESTABLE`
- `CONTRADICTED`

Novelty never upgrades an evidence state.

## Domain safety boundaries

### App / software

Automatic exploration is allowed only in sandbox/test/disposable state unless the exact action is independently authorized as safe and reversible. Production/user data changes are out of scope for v0.

### Historical archive / 100y

Explorer output must be framed as `QUESTION`, `HYPOTHESIS`, `CONFLICT`, or `MISSING_EVIDENCE`. It must not directly promote a reading, identity, date, kinship, or translation into canon. Image/source evidence and existing uncertainty markers remain authoritative.

### Collectibles / market

Explorer may discover data gaps, price anomalies, listing patterns, platform differences, seller patterns, and candidate opportunities. It may not execute a purchase/sale or treat novelty as expected profit. Real transaction decisions require human approval.

## Stop conditions

Stop exploration when any of these occurs:

- the next action crosses a production/destructive/purchase/publication/canonical-write boundary;
- exact target identity is unresolved;
- the candidate requires unavailable evidence;
- exploration is repeating semantically equivalent states without new utility;
- token/time/test budget is exhausted;
- a candidate becomes high-consequence enough to require a different owner or explicit approval.

## Default v0 budget

Per normal work item:

- Explorer: 5 candidates maximum;
- Evaluator: top 3 maximum;
- Reproducer: top 1–2 maximum;
- rule promotion: zero by default, proposal only.

This prevents Discovery from becoming a second infinite queue.
