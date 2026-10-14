# Challenge 4 · Running but never Ready

**Round 1** · Suggested time limit: 5 minutes

`web` Pods are `Running`, but `READY` says `0/1` and the Service has no endpoints.

```sh
kubectl apply -f broken.yaml
kubectl get pods,endpointslices -n c4
```

**Goal:** both Pods `1/1 Ready`, **with** a working readiness probe.

```sh
./check.sh
```

<details>
<summary>Hint</summary>

`kubectl describe pod -n c4 -l app=web` shows why the probe fails. Which paths does a plain
nginx actually serve?

</details>
