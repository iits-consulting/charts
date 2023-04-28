How to install:

```shell
    helm repo add iits-charts https://charts.iits.tech
    helm search repo YOUR_CHART_NAME
    helm install YOUR_CHART_NAME iits-charts/YOUR_CHART_NAME
```

## acceptance criteria

Any helm chart provided by iits-consulting needs to adhere to the following acceptance criteria:

* The README.md has to contain a description about the chart
* Enable custom annotations in values.yaml
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
* Have a NOTES.txt that provides information about the deployment
