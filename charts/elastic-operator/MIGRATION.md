# Migration from elasticsearch to elastic-operator

Generally updates should just work in-place. But:

* Have a backup at hand - just in case
* Make sure that the persistent volumes of elasticsearch have "Retain" as their reclaim policy and wont get deleted at any point
* Check out the settings of the new chart. They should be compatible with the ones from elasticsearch chart (at least for the default config). But take a look at them and configure the chart. Some keys and locations of settings might have changed.
* tested from elasticsearch `8.5.1` to `8.18.0` (you can configure the version of elasticsearch in elastic-operator chart)
* check out the [docs](https://www.elastic.co/docs/deploy-manage/upgrade/prepare-to-upgrade) on how to prepare for an upgrade

## The migration process

**Note:** If you are using volumes that are managed by terraform you could also just delete the old elasticsearch and redeploy everything using the managed volume with the elastic-operator chart. Just make sure that the elasticsearch pods have the opportunity to **gracefully shutdown**.

### Otherwise you can use those steps as a guideline

1. Add sync window or ensure otherwise that **argocd will not sync anything automatically** or interfere with any of the other steps
2. Gracefully shutdown existing elasticsearch pods by scaling down the statefulset  
  `kubectl scale --replicas=0 -n monitoring sts/elasticsearch-master`  
  and wait until pods are shutdown
3. Shutdown filebeat and kibana pods (delete their daemonset / deployment / statefulset)
4. **Danger!** Remove old PVCs of elasticsearch
    * make really sure that the underlying PVs have **Retain** as their reclaim policy and **do not get deleted** by this step
5. Remove existing claim-ref spec from PVs yaml manifest so that they are in state "Available" again and can be bound to new PVCs  

    ```yaml
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: "..."
    spec:
      accessModes:
      - ReadWriteOnce
      capacity:
        storage: "..."
      # claimRef:                                           # DELETE
      #   apiVersion: v1                                    # DELETE
      #   kind: PersistentVolumeClaim                       # DELETE
      #   name: elasticsearch-master-elasticsearch-master-0 # DELETE
      #   namespace: default                                # DELETE
      #   resourceVersion: "7987"                           # DELETE
      #   uid: d74e4d0f-cbf6-41c3-9af9-59777afda0f5         # DELETE
      persistentVolumeReclaimPolicy: Retain
      # ... other stuff
    ```

6. _(Optional)_ create new PVCs that bind to that PVs by using the naming that is outlined below. You probably do not need this if you control the persistence by the elastic-operator chart (using `cce` or `aks` settings in values.yaml)
7. **Danger!** Remove old deployment / helm-release of elasticsearch
    * make really sure that the underlying PVs have **Retain** as their reclaim policy and **do not get deleted** by this step
    * Maybe make use of the argocd annotation  
    `argocd.argoproj.io/sync-options: Delete=false`  
    to stop argocd from deleting PVs
8. Deploy elastic-operator chart

## PVC names in the two charts

* Naming of PVCs of **elasticsearch** chart:
  * **Template:** `{{ .Values.elasticsearch.clusterName }}-{{ .Values.elasticsearch.nodeGroup }}-{{ .Values.elasticsearch.clusterName }}-{{ .Values.elasticsearch.nodeGroup }}-{{ $i }}`
  * `elasticsearch-master-elasticsearch-master-0` (using default values)
  * `elasticsearch-master-elasticsearch-master-1` (using default values)
* Naming of PVCs of the **elastic-operator** chart:
  * **Template:** `elasticsearch-data-{{ $.Release.Name }}-es-default-{{ $i }}`
  * `elasticsearch-data-elastic-operator-es-default-0` (using default values)
  * `elasticsearch-data-elastic-operator-es-default-1` (using default values)
  