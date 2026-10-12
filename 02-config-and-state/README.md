# Exercise 2 · Config & state

**Goal:** keep configuration out of the image, see why Secrets aren't encrypted, and
watch a StatefulSet keep its identity and data.

**Concepts:** ConfigMap, Secret, env vars vs mounted files, StatefulSet, PVC, headless Service

## Steps

1. **Create config and a Secret,** then a Deployment that uses both
   (as env vars and as a mounted file).

   ```sh
   kubectl apply -f configmap.yaml -f secret.yaml
   kubectl apply -f deployment-with-config.yaml
   kubectl rollout status deploy/web
   ```

2. **Look inside** a Pod.

   ```sh
   kubectl exec deploy/web -- env | grep -E 'DB_|LOG_LEVEL'
   kubectl exec deploy/web -- cat /etc/web/app.properties
   ```

3. **Decode the Secret.** ❓ What does this tell you about Secrets?

   ```sh
   kubectl get secret db-creds -o jsonpath='{.data.DB_PASSWORD}' | base64 -d
   ```

4. **Change the config** and find out what updates on its own.

   ```sh
   kubectl edit configmap web-config     # change LOG_LEVEL and the greeting
   kubectl exec deploy/web -- env | grep LOG_LEVEL          # env var?
   kubectl exec deploy/web -- cat /etc/web/app.properties   # file? (wait ~1 min)
   kubectl rollout restart deploy/web                       # picks up env changes
   ```

5. **StatefulSet:** stable names, stable storage.

   ```sh
   kubectl apply -f statefulset.yaml
   kubectl get pods -l app=db -w          # db-0 first, then db-1
   kubectl get pvc                        # one claim per Pod
   kubectl delete pod db-0
   kubectl exec db-0 -- cat /data/log.txt # two lines: the data survived
   kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never -- \
     nslookup db-0.db.default.svc.cluster.local
   ```

<details>
<summary>What you should see</summary>

- Step 3 prints `s3cr3t`. base64 is encoding, not encryption: protect Secrets with RBAC
  and encryption at rest.
- Step 4: the **mounted file** updates by itself after up to a minute; the **env var**
  only changes after `rollout restart`, because env vars are read once at start.
- Step 5: the Pod comes back with the **same name** and the **same volume**, so
  `/data/log.txt` has one line per start.

</details>

More: the official [StatefulSet tutorial](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/).
