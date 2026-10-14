# Challenges · Fix it fast

Short, timed debugging challenges. Each one deploys something **broken** into its own
namespace (`c1` … `c7`). Find out what's wrong, fix it, and prove it with `./check.sh`.

| Round | Challenge | Topic |
|---|---|---|
| 1 | [`c1-pending`](c1-pending/README.md) | Scheduling, resource requests |
| 1 | [`c2-config`](c2-config/README.md) | ConfigMaps, env vars |
| 1 | [`c3-service`](c3-service/README.md) | Services, ports |
| 1 | [`c4-readiness`](c4-readiness/README.md) | Readiness probes |
| 2 | [`c5-network-policy`](c5-network-policy/README.md) | NetworkPolicy |
| 2 | [`c6-rbac`](c6-rbac/README.md) | RBAC, ServiceAccounts |
| 2 | [`c7-autoscaling`](c7-autoscaling/README.md) | HPA, requests, metrics-server |

Round 1 comes after Exercise 3, round 2 after Exercise 6 (c7 needs metrics-server from Exercise 5).

## Rules

1. `cd` into the challenge folder and break things: `kubectl apply -f broken.yaml`
2. Debug with what you learned: `get`, `describe` (read the **Events**), `logs`, `exec`
3. Fix it: `kubectl edit`, `kubectl patch`, or edit `broken.yaml` and apply it again
4. Run `./check.sh` until it says **PASS**
5. The clock is running: when time is up, we go through the answers together

Don't "fix" a challenge by deleting the thing that's broken: `check.sh` notices.
Stuck? Each README has a hint. The answers are in [`SOLUTIONS.md`](SOLUTIONS.md): no peeking until time is up.

## Start over or clean up

```sh
kubectl delete ns c1            # then apply broken.yaml again to retry
kubectl delete ns c1 c2 c3 c4 c5 c6 c7
```
