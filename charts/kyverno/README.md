# kyverno

This chart wraps kyverno and some additional components such as the policy reporter as well as
IngressRoutes/Middlewares to allow usage of the Kyverno UI. It also deploys the defualt policies as
provided by the Kyverno project.

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
