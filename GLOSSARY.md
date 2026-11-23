# Charts

Wrapper Helm charts for T Cloud Public, each one independent, checked and released by a shared pipeline.

## Language

**Changed chart**:
A chart that still exists and has at least one file in its directory differing from the comparison base.
_Avoid_: Affected chart, touched chart, modified chart

**Targeted chart**:
A chart the pipeline acts on in a given run: every changed chart, or every chart when a shared input changed.
_Avoid_: Affected chart, selected chart

**Shared input**:
A file outside the chart directories that influences the pipeline's result for every chart.
_Avoid_: Global file, common file

**Comparison base**:
The repository state a change is measured against to decide which charts are changed charts.
_Avoid_: Baseline, reference commit
