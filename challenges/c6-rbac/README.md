# Challenge 6 · Forbidden

**Round 2** · Suggested time limit: 7 minutes

The CI pipeline runs as the `deployer` ServiceAccount in `c6`. It must read, create and update
Deployments there, and nothing else. Every deploy fails with `forbidden`.

```sh
kubectl apply -f broken.yaml
kubectl auth can-i create deployments -n c6 --as=system:serviceaccount:c6:deployer
```

**Goal:** `deployer` can create and update Deployments in `c6`, but can't delete them, read
Secrets, or touch other namespaces. There are **two** mistakes.

```sh
./check.sh
```

<details>
<summary>Hint</summary>

Check both halves: what the Role allows (`kubectl api-resources | grep deployments` shows
the API group) and who the RoleBinding gives it to. `roleRef` can't be edited, but `subjects` can.

</details>
