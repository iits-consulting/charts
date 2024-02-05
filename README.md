# IITS helm charts

This project contains several public charts as used by the folks at [IITS](https://iits-consulting.de/).

## Requirements

These charts are running only with a OIDC Proxy upfront and traefik as a Ingress Controller

## Installation

Take a look at the specific README.md of the chart.

## Acceptance criteria

Any helm chart provided by iits-consulting needs to adhere to the following acceptance criteria:

* The `Chart.yaml` contains all required attributes as defined in https://helm.sh/docs/topics/charts/#the-chartyaml-file
* Document values in such a way that [helm-docs](https://github.com/norwoodj/helm-docs) may generate
  a nice `README.md`
* Enable custom annotations in `values.yaml`
* Define common labels for better separation of concerns
* Configuration changes have to cause a pod restart
* Whenever possible, sensitive information should be injected by something like
  a [mutating webhook](https://banzaicloud.com/docs/bank-vaults/mutating-webhook/) rather than be part of your chart
* Container health checks need to be present
* Use subcharts to manage dependencies whenever possible
* **Document** every values.yaml variable that is meant to be adjusted
* Specify a license
* Provide a default .helmignore
* HorizontalPodAutoscaler should be present
* Have a `NOTES.txt` that provides information about the deployment

