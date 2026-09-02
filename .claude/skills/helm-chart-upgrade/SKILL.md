---
name: helm-chart-upgrade
description: Procedure for upgrading a Helm chart's dependency version(s) — especially large or multi-major jumps — with real verification instead of guesswork, ending in a CHANGELOG.md (facts) and UPGRADE.md (actions) pair. Use whenever asked to bump/upgrade a Helm chart dependency, update a subchart version, or prepare an upgrade guide for a chart. Chart-agnostic: applies to any umbrella/wrapper Helm chart, not just a specific one.
---

# Helm chart dependency upgrade

This is the procedure for bumping one or more dependency chart versions in an umbrella
Helm chart (a `Chart.yaml` with a `dependencies:` block), producing both the version bump
itself and the documentation an operator needs to safely apply it. It generalizes a
real upgrade (kube-prometheus-stack + prometheus-blackbox-exporter, a ~9-minor-version
jump) — the mechanics below aren't specific to those charts.

**Definition of done**: `Chart.yaml`/`Chart.lock`/vendored `charts/*.tgz` updated via a
real `helm dependency update`; `helm lint` and `helm template` both pass; any
downstream-vendored templates rebased against the new upstream; `CHANGELOG.md` updated
with facts only; an upgrade guide updated with actions only; no scratch/temp artifacts
left behind.

## 0. Clarify scope before touching anything

Ask the user (don't assume) whenever any of these are ambiguous:
- Which dependencies and target versions, exactly.
- Whether to actually run the package manager (`helm dependency update`, regenerating a
  real lockfile digest) or only hand-edit version strings for review. Prefer running the
  real command — a hand-edited lockfile digest is not valid and blocks real verification.
- Whether the umbrella chart's own `version:` should be bumped too, and by what
  convention (some repos mirror one dependency's version, some use their own semver,
  some just bump a patch). Check `CHANGELOG.md`/git history for the existing convention
  before proposing one.
- How any externally-managed resources the chart could otherwise own (CRDs, RBAC,
  secrets) are actually handled operationally today (Terraform, another controller,
  manual). You cannot infer this from the chart alone — ask.
- Any request to adopt a chart feature the chart's own docs label experimental/preview:
  confirm the user actually wants that now, in this same change, versus deferred.

Treat "I'm not sure what they mean by X" as a stop condition, not a guess. Getting scope
wrong here is expensive to unwind later (see §7 on reverting).

## 1. Inventory the current chart

Read, don't assume:
- `Chart.yaml` — dependency list (name, alias, repository, current version), the
  umbrella chart's own `version`/`appVersion`, any embedded install instructions
  (ArgoCD examples, etc. — these often hardcode a version string that needs bumping too).
- `Chart.lock` — confirms what's actually pinned/downloaded.
- `values.yaml` — every key the umbrella chart overrides under each dependency's alias.
  This is the surface area that can break on a version bump.
- `templates/` — anything that looks vendored/copied from a dependency (a header comment
  like "generated from X, do not edit in place" is the tell). These need special handling
  (§5) since they don't get the dependency's own bug fixes and schema evolution for free.
- Existing `CHANGELOG.md`/`UPGRADE.md`-equivalent docs — read their format and tone before
  writing new entries; match the established convention rather than inventing a new one.

## 2. Pull the real old and new chart sources locally

Don't rely on prose summaries alone — pull the actual tarballs for both the current and
target version and diff them directly:

```bash
helm repo add <repo-name> <repo-url>          # if not already added
helm repo update
helm pull <repo-name>/<chart> --version <old-version> -d <scratch>/old --untar
helm pull <repo-name>/<chart> --version <new-version> -d <scratch>/new --untar
```

This gives you ground truth for:
- `Chart.yaml` — the dependency's own `appVersion` (the embedded application's real
  version) and its own sub-dependencies' versions (diff `dependencies:` blocks old vs
  new to see what moved).
- `values.yaml` — diff old vs new, but only care about the subset of keys the umbrella
  chart actually overrides (§1). Look for: renamed keys, removed keys, changed defaults,
  new required keys, new optional features relevant to what the umbrella overrides.
- `templates/` — needed for §5 if anything is vendored.

If `helm`/`helm-docs`/any other CLI isn't installed in the working environment, download
the release binary directly (match the OS/arch, e.g. `uname -m`) rather than skipping the
step — these tools are usually a single static binary, no package manager or Docker
required.

## 3. Research breaking changes from primary sources

In priority order, since not every project maintains all of these:
1. A per-version `CHANGELOG.md` in the dependency's own source repo, if it exists.
2. An `UPGRADE.md`/migration-guide doc, if it exists — usually organized by
   version-boundary sections ("From X.x to Y.x"). Read every section whose range overlaps
   your old→new jump, not just the adjacent ones.
3. If neither exists (common for monorepo chart collections that don't publish a
   per-chart changelog): the project's GitHub Releases list, or `git log` scoped to the
   chart's subdirectory in its source repo.
4. For an embedded application's *own* breaking changes (not just the chart wrapper) —
   e.g. a chart bundling Grafana, and Grafana itself crossed a major version — go to that
   application's own breaking-changes/upgrade-guide docs, not just the chart's.

**Do not trust an intermediate version boundary's stated number as the final number.**
A migration doc's "From 83.x to 84.x: upgrades Grafana to v13.0.0" describes *that specific
boundary* — if your target is several releases further, pull the actual target tarball
(§2) and read the real bundled `appVersion`/image tag directly. Report the verified
number, not the doc's number, and say so explicitly if they differ.

## 4. Diff impact against what the umbrella chart actually overrides

For every dependency values-key the umbrella chart sets (from §1), check the old-vs-new
`values.yaml` diff (§2) for: renamed, removed, retyped, or newly-required keys. Report
findings as:
- **Breaking** — key gone/renamed/retyped; a concrete fix is needed.
- **Action required** — behavior or default changed in a way relevant to this
  deployment's config, even if no key rename occurred.
- **Informational** — real change, but doesn't touch anything this chart overrides.
- **None** — verified unchanged.

Also check anything the chart *doesn't* set but that changed defaults in a way that could
matter (e.g. a base image switching to a different variant, a security context default
changing). Don't limit the check to only literal key renames.

## 5. Rebase vendored/copied templates

If §1 found a hand-copied template (e.g. a customized rule/policy resource forked from
the dependency's own template because you need one deliberate deviation from the
default), the correct rebase technique is:

1. Render what upstream would produce *with your real values* by temporarily flipping the
   override off and enabling the dependency's own version of that resource:
   ```bash
   helm template . --set <dependency>.<the-toggle-you-disabled>=true \
     --show-only <path-to-that-template> > <scratch>/upstream-rendered.yaml
   ```
2. Diff that rendered output against your current vendored file to see everything that
   drifted — not just the one deviation you remember making. Vendored files rot silently;
   expect more drift than you think.
3. Rewrite the vendored file starting from the new rendered output, then re-apply only
   the intentional deviation(s) on top. Do not hand-patch the old file piecewise — that's
   how the drift accumulated in the first place.
4. Re-render your new vendored file and diff it against the pure-upstream render from
   step 1 to confirm the *only* differences remaining are your intentional ones.

## 6. Apply the version bump

```bash
# edit Chart.yaml dependency version(s)
helm dependency update .
helm lint . <required --set flags for empty-string-required values>
helm template . <same --set flags> > /dev/null   # must exit 0, no errors
```

Re-run lint + template after every subsequent substantive change (values.yaml edits,
template rebases) — it's cheap and catches regressions immediately rather than at the
end. If the repo uses a docs generator (e.g. `helm-docs`), regenerate `README.md` too,
matching the generator version already pinned/used in the repo if stated anywhere.

## 7. Empirical verification, when feasible

Static doc review misses things — dashboards that render differently, config keys that
are technically unchanged but behave differently, template output that silently changed.
Where the target application ships a standalone binary or the chart ships enough to run
locally, prefer *running it* over reading about it:

- Download the actual application release binary directly (matching architecture) rather
  than assuming Docker/Kubernetes access is required — most projects ship a plain binary
  tarball alongside container images.
- Configure it minimally to mirror how this chart actually provisions it (e.g. the same
  file-based provisioning mechanism a sidecar would use, the same config keys the umbrella
  chart sets).
- Inspect real logs and API/CLI output for warnings/errors, not just a green exit code.
- Where behavior depends on version-specific logic (e.g. "does this legacy field still
  auto-migrate"), it's worth pulling the actual source of that logic at the target
  version tag and reading it directly rather than trusting a general impression — this
  produces a verifiable, citable answer instead of a guess.
- Do all of this in a scratch/temp directory, and delete it completely when done (binary,
  extracted files, generated config, logs). Leave the working repo exactly as it should be
  committed — no test artifacts.
- If the environment's temp filesystem is small (e.g. a size-limited `tmpfs`), a large
  binary download can exhaust it; check available space first, and if needed use a
  different writable location for scratch work rather than skipping the verification —
  just clean it up just as thoroughly afterward.

This step is optional when infeasible (no runnable binary, no safe way to approximate the
real environment) — say so explicitly rather than skipping it silently, and fall back to
the static diff/doc findings from §3-4.

## 8. Write the documentation: two files, two jobs

Always split into two artifacts, even for a small bump. Match the target repo's existing
file names/format if it already has this convention; otherwise create both:

**`CHANGELOG.md` (or equivalent) — facts only.**
What changed, in this release, full stop. No instructions, no "you must", no links framed
as required reading, no rationale for decisions. If a fact needs a "why", that's still a
fact ("X was evaluated but not adopted because Y") — a directive to the reader ("you must
do Y before upgrading") is not. Bullet list, one line per fact:
```
- Bump `<dependency>` to <version> (<embedded-app> vX → vY, ...)
- Rebased `<vendored-template>` against upstream <version>; kept deviation: <what>
- 📖 See <upgrade-guide-filename> for the upgrade procedure
```

**Upgrade guide (`UPGRADE.md` or equivalent) — actions only.**
What an operator must *do*. Never restate the "what changed and why" narrative that
belongs in the changelog — link to it if needed, don't duplicate it. Structure:
1. A short intro: what's being bumped, old→new, whether intermediate boundaries exist
   that don't need individually addressing when jumping straight to the target.
2. A **risk summary table**: area | severity | one-line action-or-"no action needed",
   each linking to its step. Generate this from real findings (§3-4), not boilerplate —
   include a row for things explicitly checked-and-fine, not just things that need work.
3. A **pre-flight checklist**.
4. **Numbered steps**, each ending in a concrete "Action: ..." line (including "Action:
   none" when a step's purpose was to rule something out). Every step should be something
   to *do* or *verify*, not a change log of what was already done to the repo — an
   already-applied fix gets one line here ("this was already applied; re-verify behavior
   post-upgrade") with the detail in the changelog, not a re-explanation of the diff.
5. A **post-upgrade verification checklist**.
6. **Rollback** guidance.
7. **References** (links used during research).

If a decision was deliberately deferred or reverted mid-conversation (see §9), make sure
neither doc still describes the deferred/reverted state as done — this is a common
consistency bug when scope changes after the docs were first drafted.

## 9. Handle risky or cross-system decisions explicitly

Some changes have blast radius beyond the chart file diff — e.g. switching which system
owns a resource (moving CRD management from an external tool to the chart itself),
enabling a feature the dependency's own docs label preview/experimental, or anything that
would conflict with another system's state if not coordinated. For these:
- Don't fold the change in silently alongside routine version bumps.
- Explain the mechanism concretely (what will actually happen, verified by rendering/
  reading the real templates — not a guess) and the coordination required with any other
  system involved.
- If the user asks for it "right away" despite the risk, do it, but keep the risk and
  required coordination steps clearly documented rather than downplaying them because the
  user overrode the caution.
- If the user later reverts the decision, revert it completely and consistently: the
  values/config change itself, the changelog entry, the risk-table row, every step and
  checklist item in the upgrade guide that referenced it, and any cross-references
  between docs. Grep for the feature/decision name across all touched files before
  declaring the revert done.

## 10. When corrected on a fact, re-verify at the source and propagate

If the user (or new evidence) contradicts something you wrote, re-verify directly against
the primary source (the actual tarball/binary/source file, not the earlier summary) before
changing anything — don't just defer to whichever claim is more recent. Once confirmed,
fix it everywhere it was stated (changelog, upgrade guide, risk table, any inline
commentary), not just in the one place it was pointed out.

## Anti-patterns to avoid

- Hand-editing `Chart.lock` digests instead of running `helm dependency update`.
- Treating an upstream migration doc's version-boundary text as the final target version
  without checking the actual target tarball.
- Patching a vendored template file in place instead of re-rendering upstream and
  rebasing from that.
- Putting "what changed" narrative in the upgrade guide, or "what to do" instructions in
  the changelog.
- Silently enabling a preview/experimental upstream feature as part of an unrelated
  version bump.
- Leaving scratch downloads, extracted tarballs, or test binaries in the working repo.
- Re-stating deferred/reverted decisions as adopted in docs after the decision changed.
