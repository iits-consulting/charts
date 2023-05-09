# kyverno

This chart wraps the upstream kyverno chart and adds a few useful policies:

- Verify all images are signed with cosign
- Verify all images come from allowed image repositories

## Running tests

To quickly check if it works as intended run the tests. This requires the kyverno binary.

```shell
cd /toplevel/directory/of/this/repo/test/kyverno
kyverno test .
```

## Acceptance criteria

Any helm chart provided by iits-consulting needs to adhere to the following acceptance criteria:

- [x] The README.md has to contain a description about the chart
- [ ] Enable custom annotations in values.yaml (does not apply)
- [ ] Define common labels for better separation of concerns
- [ ] Whenever possible, sensitive information should be injected by something like
  a [mutating webhook](https://banzaicloud.com/docs/bank-vaults/mutating-webhook/) rather than be part of your chart
- [x] Use subcharts to manage dependencies whenever possible
- [x] **Document** every values.yaml variable that is meant to be adjusted
- [x] Specify a license
- [x] Provide a default .helmignore
- [ ] Have a NOTES.txt that provides information about the deployment
