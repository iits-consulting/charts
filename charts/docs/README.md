# Chart
A super basic chart that deploys a container containing a docs built with docusaurus.

## Usage
Find the block that looks like:
```yaml
image:
  repository: ""
  tag: ""
  pullPolicy: Always
```
and replace the empty quotes with the image you want to use. If you don't it will default to the latest image [here](https://gitlab.iits.tech/fixedpricedocumentation/docs-from-env/container_registry/715). You'll need to create a secret to pull from the CR.
I created mine like with the following block:
```bash
kubectl create secret docker-registry gitlab-registry-secret \
 --docker-server=LINK_TO_YOUR_REGISTRY_WITHOUT_PROTOCOL \
 --docker-username=YOUR_USERNAME \
 --docker-password=YOUR_GITLAB_ACCESS_TOKEN \
 --docker-email=YOUR_EMAIL
```
Make sure to update the environment variables in your `values.yaml`. A config reference can be found [here](https://gitlab.iits.tech/fixedpricedocumentation/docs-from-env#configuration).
The environment variables are read when the container starts, so if something isn't visible, restarting the container should fix it.

And that should be it!

## Updating

If a new container has been pushed, delete the container. With a `pullPolicy` of `Always`, a new image should be pulled.  
