# kyverno CLI tests

Behavior tests of the CEL policies (policies.kyverno.io) of this chart, run with the kyverno CLI against policies rendered by helm. Rendering details (value validation, expression layout, kinds, labels) are covered by helm-unittest in `tests/*_test.yaml`, so the CLI tests only assert admission results and mutation output.

Run: `tests/cli/run.sh --require-tests --warnings-as-errors` (renders into the gitignored `.rendered/`, then `kyverno test`). Needs `helm`, `yq`, `kyverno`.

## Layout

- `<fixture>/values.yaml`: `default-on` enables everything with chart defaults, `excludes` enables everything with exclusions and non-default knobs, `replace` and `replace-flat-path` replace the prepend policy (the two cannot be combined), `registries` is the allow list variant, `pullsecret-namespaces` limits pull secrets to namespaces (`injectOnly` next to a cloned `existingSecretRef`).
- `render.sh`: renders the chart once per fixture and splits it into `.rendered/<fixture>/<policy name>.yaml`. A helm error fails the run.
- `<fixture>/kyverno-test.yaml`: one Test for all validating and generating policies of the fixture.
- `<fixture>/<mutating policy>/kyverno-test.yaml` and `patched.yaml`: one Test per mutating policy. Mutations chain inside a Test (a second MutatingPolicy changes the expected resource of the first), so they cannot share one.
- `default-on` carries the behavior matrix, the other fixtures only the resources whose outcome the fixture changes (an exclusion, an allow list entry, a knob).
- `resources/`: shared resource matrix.

## Conventions and caveats

- The CLI silently ignores a result whose resource is not in the Test's `resources`. `run.sh` therefore fails before `kyverno test` when a result names a resource (`name` or `namespace/name`) that no loaded file defines.

- `result: skip` means excluded or not matched. It is reliable: the CLI reports "Want skip, got pass" when the policy does mutate. `result: pass` on an excluded resource is NOT reliable (reported as `Pass / Excluded`), so negative cases are always written as `skip`.
- Mutation expectations live in `patched.yaml` next to the test, generated from the CLI output and reviewed by hand. The CLI diffs the whole resource, a wrong expectation fails with `Resource diff`.
- Mutating tests are CREATE only (the CLI has no `--operation`). A failing expression shows up as `error` in `kyverno apply --policy-report`, not on stdout.
- `disallow-unsigned-images` (ImageValidatingPolicy) has no CLI test: `*` images make the CLI contact registries and signatures cannot be verified offline. Rendering is covered by helm-unittest, signature verification only on a cluster.
- Pull secret `namespaceSelector`: the CLI provides no `namespaceObject` (`no such key: metadata`), so it is covered by helm-unittest and only verified on a cluster.
- Generate: `generatedResource` tests of the GeneratingPolicies need the source Secrets in `context.yaml`. `synchronize` and sync after deletion are not testable with the CLI.
- The upstream kyverno-policies (PSS) are not tested with the CLI, that would test upstream. The chart's kube-system exclusion is covered by helm-unittest (`policies-pss_test.yaml`).
