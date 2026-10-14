# Challenge 1 · Stuck in Pending

**Round 1** · Suggested time limit: 5 minutes

The `api` team deployed two replicas an hour ago. They're still not running.

```sh
kubectl apply -f broken.yaml
kubectl get pods -n c1
```

**Goal:** both `api` Pods `Running`, with a sensible CPU request (don't remove it).

```sh
./check.sh
```

<details>
<summary>Hint</summary>

Pending means the scheduler can't place the Pod. `kubectl describe pod -n c1 <pod>` and read
the Events at the bottom. Then compare with `kubectl describe node | grep -A6 Allocatable`.

</details>
