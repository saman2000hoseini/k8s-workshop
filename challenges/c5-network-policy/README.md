# Challenge 5 · Locked out

**Round 2** · Suggested time limit: 7 minutes

The namespace is locked down with a default-deny policy, and a second policy is supposed to let
`frontend` call `api`. It doesn't.

```sh
kubectl apply -f broken.yaml
kubectl exec -n c5 deploy/frontend -- wget -T 3 -qO- http://api
```

**Goal:** `frontend` reaches `api`; any other Pod is still blocked. Keep `default-deny`.

```sh
./check.sh
```

<details>
<summary>Hint</summary>

Policies select Pods by label. Compare `kubectl get networkpolicy api-from-frontend -n c5 -o yaml`
with `kubectl get pods -n c5 --show-labels`.

</details>
