# Intrinsic Discovery v0 — Execution Pack

```yaml
date: 2026-08-30
canonical: false
needs_codex_review: true
state: executable_candidate
scope: cross-repo discovery / failure discovery / experience corpus
source_strategy: Analog-First AI Three-Axis Strategy + Intrinsic Discovery adaptation
```

## Purpose

Turn the current reactive loop (`failure -> correction -> replay`) into a bounded proactive loop that searches for unobserved states, evaluates whether they matter, reproduces them safely, and promotes only durable lessons.

Core principle:

> Explorer discovers. Evaluator judges. Reproducer verifies. Promoter proposes. Humans/canonical gates authorize durable changes.

Do not use novelty as truth, purchase authority, production-write authority, or historical-document proof.

## Files

- `DISCOVERY_CONTRACT.md` — authority, states, safety boundaries, required outputs.
- `DISCOVERY_RECORD.schema.json` — portable record shape.
- `discovery_archive.jsonl` — append-only candidate experience archive. Starts with a metadata row.
- `PROMOTION_GATE.md` — discovered -> reproduced -> regression/rule promotion rules.
- `PROMPT_RUN_ORDER.md` — which prompt to run, when, and in what order.
- `PROMPT_PACK.md` — copy/paste prompts for generic discovery plus App, historical archive, and collectibles adapters.
- `Invoke-DiscoveryPass.ps1` — local helper that creates a ready-to-run prompt packet; it does not call any model/API and does not modify product data.

## Start here: v0 manual/semi-auto

1. Finish a normal task.
2. Run the **Session-End Discovery Pass** from `PROMPT_PACK.md` with budget `5 candidates`.
3. Append candidate records to `discovery_archive.jsonl` only after checking that each record is syntactically valid and contains evidence scope.
4. Run **Evaluator** on the top 1–3 candidates.
5. Only for safe/high-value candidates, run **Reproducer** in sandbox/test/read-only context.
6. Run **Promoter** only after reproduction or an explicit `NOT_TESTABLE` boundary.
7. Promote to regression/SOP/rule only through `PROMOTION_GATE.md`.

## Quick semi-auto commands

Run from this folder in PowerShell. The helper generates a prompt packet under `runs/`; it does not call an AI model itself.

### Planning app

```powershell
.\Invoke-DiscoveryPass.ps1 `
  -Domain app `
  -Target "planning app / recently changed flow" `
  -CurrentTask "describe the feature, fix, or state transition just completed" `
  -RecentChange "describe the exact recent change" `
  -EvidencePaths "tests, diff, screenshots, logs, or relevant repo paths" `
  -Budget 5
```

### Historical archive / 100y

```powershell
.\Invoke-DiscoveryPass.ps1 `
  -Domain archive `
  -Target "exact manuscript/page/work range" `
  -CurrentTask "current reading, translation, identity, chronology, or kinship question" `
  -EvidencePaths "exact images/files/notes/external evidence available" `
  -Budget 5
```

### Collectibles / Collector OS

```powershell
.\Invoke-DiscoveryPass.ps1 `
  -Domain collector `
  -Target "exact coin/stamp/market slice" `
  -CurrentTask "current observed prices/listings/data coverage" `
  -EvidencePaths "read-only market sources or DB excerpt" `
  -Budget 5
```

Then copy the generated `runs/..._discovery_prompt.md` into the chosen model/session. Feed the returned top candidates into the Evaluator prompt in `PROMPT_PACK.md`.

## Recommended first guinea pig

Use the planning app first. It has a real user, recurring usage, observable ground truth, and a reversible test environment. Start with one feature or recently changed flow, not the entire app.

Suggested first manual prompt:

```text
Domain: app
Target: planning app
Current task: the most recently changed user flow
Budget: 5 discovery candidates
Goal: find untested state/action combinations that are meaningfully different from existing normal-path tests.
Constraints: sandbox/test data only; no production data mutation; no main-branch write.
```

## Success signal for v0

Do not measure success by number of weird cases generated. Measure:

- useful novel candidates / total candidates;
- reproduced failures / evaluated candidates;
- regressions added / reproduced failures;
- repeated human rework avoided;
- archive growth without CLAUDE/AGENTS rule bloat.

## Non-goals

- no RL/GRPO training in v0;
- no autonomous production actions;
- no automatic purchases;
- no automatic historical-text canon promotion;
- no automatic `CLAUDE.md`, `AGENTS.md`, `Rules.md`, or `main` edits;
- no claim that a novel state is valuable merely because it is new.

## Promotion target

If v0 repeatedly finds useful, reproducible cases with acceptable cost, Codex may promote the minimal proven pieces into canonical `docs/`, `tools/`, regression owners, or per-repo adapters. Until then this folder is a reviewable executable candidate, not canonical operating policy.
