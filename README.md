## Usage

see main branch of this project

export CHART_NAME="Chart name under charts folder"

export CHART_REPO_NAME="GITHUB PROJECT NAME"

helm repo add $CHART_REPO_NAME https://iits-consulting.github.io/$CHART_REPO_NAME/

helm search repo $CHART_NAME

helm install $CHART_NAME $CHART_REPO_NAME/$CHART_NAME
