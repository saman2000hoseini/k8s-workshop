# Challenge 7 · The autoscaler is blind

**Round 2** · Suggested time limit: 7 minutes · Needs metrics-server (Exercise 5)

The HPA for `web` was created, but it never scales. Its TARGETS column says `<unknown>`.

```sh
kubectl apply -f broken.yaml
kubectl get hpa -n c7
```

**Goal:** the HPA shows a real CPU percentage.

```sh
./check.sh
```

<details>
<summary>Hint</summary>

`kubectl describe hpa web -n c7` is vague here: it only says it "did not receive metrics".
Remember the HPA slide: CPU utilization is a percentage *of* something. Does the Deployment
set it? `kubectl get deploy web -n c7 -o jsonpath='{.spec.template.spec.containers[0].resources}'`

</details>
