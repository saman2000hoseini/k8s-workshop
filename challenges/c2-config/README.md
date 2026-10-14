# Challenge 2 · Missing greeting

**Round 1** · Suggested time limit: 5 minutes

`greeter` should print the greeting stored in the `greeter-config` ConfigMap. It never starts.

```sh
kubectl apply -f broken.yaml
kubectl get pods -n c2
```

**Goal:** `greeter` is running and its logs show the greeting from the ConfigMap
(no hard-coded values).

```sh
./check.sh
```

<details>
<summary>Hint</summary>

The STATUS column is unusual here. `kubectl describe pod -n c2 -l app=greeter`, then compare the
Deployment's `configMapKeyRef` with `kubectl get configmap greeter-config -n c2 -o yaml`.
Keys are case-sensitive.

</details>
