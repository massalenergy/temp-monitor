# Prompt Run Order v0

Use the smallest loop that fits the task. Do not run every prompt by default.

## A. Normal task closeout

Run:

1. `Session-End Discovery Pass`
2. `Evaluator` on at most the top 3
3. `Reproducer` on at most the top 1–2 safe candidates
4. `Promoter` only for reproduced/high-value candidates

Default budget: 5 -> 3 -> 2 -> proposal only.

## B. App / planning app

Run:

1. `App Explorer`
2. `Evaluator`
3. `Reproducer`
4. `Promoter`

First targets should be one recently changed flow, one state transition, or one bug fix. Do not explore the whole application in one run.

## C. Historical archive / 100y

Run:

1. `Archive Question Explorer`
2. `Evaluator`
3. evidence retrieval / source inspection
4. `Reproducer` interpreted as evidence verification, not synthetic execution
5. `Promoter` only to question/regression/research workflow candidates unless canonical historical evidence independently supports a content change

The Explorer may generate questions, hypotheses, conflicts, and missing-evidence leads. It may not finalize readings or identities.

## D. Collectibles / Collector OS

Run:

1. `Collector Market Explorer`
2. `Evaluator`
3. read-only market/source verification
4. optional human transaction decision

Do not run `Promoter` into a purchase action. Promotion means only data-collection workflow, watchlist logic, or regression/analysis rule candidate.

## E. When to skip Discovery

Skip when:
- the task was trivial and produced no reusable state;
- the target identity is unresolved;
- there is no safe/read-only/sandbox next action;
- the discovery budget would cost more than the likely learning value;
- the task already exercised the same known regression set and no meaningful state changed.

## F. Prompt variables

Fill these before running a prompt:

```text
DOMAIN = app | archive | collector | generic
TARGET = exact app/feature/document/market slice
CURRENT_TASK = what just changed or was investigated
RECENT_CHANGE = exact change/fix/new evidence
KNOWN_CASES = relevant known regressions or archive excerpt
EVIDENCE_PATHS = exact files/links/images/receipts available
BUDGET = default 5 candidates
RISK_BOUNDARY = sandbox/read-only/no-purchase/no-canon-write/etc.
```

## G. Output handling

- Candidate records go to `discovery_archive.jsonl` only after syntax/evidence-scope check.
- Keep rejected candidates if they teach the Explorer what is already known; mark `rejected` rather than deleting by default.
- Do not write canonical rules from the prompt output. Use `PROMOTION_GATE.md`.
- If a candidate is `NOT_TESTABLE`, record the exact missing gate and stop that branch.
