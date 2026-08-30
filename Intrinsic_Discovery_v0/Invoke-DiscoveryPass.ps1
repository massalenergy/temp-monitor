param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('app','archive','collector','generic')]
    [string]$Domain,

    [Parameter(Mandatory=$true)]
    [string]$Target,

    [Parameter(Mandatory=$true)]
    [string]$CurrentTask,

    [string]$RecentChange = '',
    [string]$EvidencePaths = '',
    [string]$RiskBoundary = '',
    [int]$Budget = 5,
    [string]$ContextFile = '',
    [string]$ArchivePath = '',
    [int]$ArchiveTail = 30,
    [string]$OutputDir = ''
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($ArchivePath)) {
    $ArchivePath = Join-Path $root 'discovery_archive.jsonl'
}
if ([string]::IsNullOrWhiteSpace($OutputDir)) {
    $OutputDir = Join-Path $root 'runs'
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$archiveExcerpt = '(archive unavailable or empty)'
if (Test-Path $ArchivePath) {
    $lines = Get-Content -LiteralPath $ArchivePath -Encoding UTF8
    if ($lines.Count -gt 0) {
        $archiveExcerpt = ($lines | Select-Object -Last $ArchiveTail) -join "`n"
    }
}

$context = ''
if (-not [string]::IsNullOrWhiteSpace($ContextFile)) {
    if (-not (Test-Path $ContextFile)) {
        throw "ContextFile not found: $ContextFile"
    }
    $context = Get-Content -LiteralPath $ContextFile -Raw -Encoding UTF8
}

if ([string]::IsNullOrWhiteSpace($RiskBoundary)) {
    switch ($Domain) {
        'app'       { $RiskBoundary = 'sandbox/test data only; no production data; no main/canonical write' }
        'archive'   { $RiskBoundary = 'question/hypothesis/conflict only; no invented characters; no canon promotion' }
        'collector' { $RiskBoundary = 'read-only market discovery; no purchase/sale/message/public claim' }
        default     { $RiskBoundary = 'no production/destructive/purchase/publication/canonical-write action' }
    }
}

$domainInstruction = switch ($Domain) {
    'app' {
@'
APP MODE:
Search one bounded user flow for meaningful unobserved state/action combinations. Prefer sequence/order/boundary/stale-state cases over random fuzzing. Consider create/edit/delete/recreate, save/restart/edit, duplicate objects, empty/min/max values, date/time transitions, interrupted/repeated actions, stale state after navigation/reload, and safely testable permission/offline/error-return paths. Sandbox/test data only. Do not touch production user data or main.
'@
    }
    'archive' {
@'
ARCHIVE MODE:
Generate only QUESTION, HYPOTHESIS, CONFLICT, or MISSING_EVIDENCE leads. Prioritize chronology conflicts, identity/kinship/place ambiguity, dependent evidence, contradictory source classes, and neighboring context that could change interpretation. Never invent unreadable characters, fill gaps from context, or promote a hypothesis into transcription/translation/canon. Preserve uncertainty markers and distinguish independent evidence from evidence discovered through the same candidate route.
'@
    }
    'collector' {
@'
COLLECTOR MODE:
Search for decision-relevant data gaps, anomalies, listing patterns, and cross-platform differences across item/year/type, condition, ask price, observed sale price, platform, seller/listing pattern, duration, bundle/single, and provenance. Novelty is not profit and a strange listing is not a buy signal. Do not buy, sell, message sellers, publish claims, or change transaction state. Suspected manipulation/counterfeit/reproduction remains a verification question until evidenced.
'@
    }
    default {
@'
GENERIC MODE:
After the completed task, find materially different states, action sequences, questions, conflicts, anomalies, or evidence gaps that have not yet been meaningfully observed. Optimize for learning value, not weirdness.
'@
    }
}

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$safeDomain = $Domain -replace '[^A-Za-z0-9_-]', '_'
$outPath = Join-Path $OutputDir "${timestamp}_${safeDomain}_discovery_prompt.md"

$prompt = @"
# Discovery Run Packet

Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')
Contract: DISCOVERY_CONTRACT.md
Promotion gate: PROMOTION_GATE.md
Schema: DISCOVERY_RECORD.schema.json

## Role

You are the Explorer. Do not verify, fix, buy, publish, or promote. Generate bounded candidates for a separate Evaluator.

$domainInstruction

## Inputs

DOMAIN: $Domain
TARGET: $Target
CURRENT_TASK: $CurrentTask
RECENT_CHANGE: $RecentChange
EVIDENCE_PATHS: $EvidencePaths
RISK_BOUNDARY: $RiskBoundary
BUDGET: $Budget

## Optional context

$context

## Nearest-known/archive excerpt

--- BEGIN ARCHIVE EXCERPT ---
$archiveExcerpt
--- END ARCHIVE EXCERPT ---

## Required behavior

1. Generate at most $Budget materially different candidates.
2. Novelty and utility are independent 0.00–1.00 scores with separate rationales.
3. Name the nearest known case or state that none is visible in the supplied excerpt.
4. Preserve evidence state. Novelty never upgrades UNKNOWN/NOT_TESTABLE/CONTRADICTED.
5. Do not cross the risk boundary.
6. Prefer candidates that could change a decision, prevent recurrence, expose an important blind spot, or create a useful regression/workflow.
7. Return a coverage summary, candidate JSON records, top-3 Evaluator handoff, and a stop note.
8. Set reproduction_state=NOT_ATTEMPTED and promotion_state=discovered.
9. Use real ids in the form DISC-YYYYMMDD-NNN; do not reuse the metadata id DISC-00000000-000.
10. If exact target identity or critical evidence is unresolved, generate a bounded reconciliation candidate instead of broad fan-out.

## Next step

After this Explorer output, run a separate Evaluator role on at most the top 3. The Evaluator must rescore novelty/utility, reject low-value novelty aggressively, and nominate only safe candidates for reproduction. Do not append raw model output to canonical rules.
"@

Set-Content -LiteralPath $outPath -Value $prompt -Encoding UTF8
Write-Output $outPath
