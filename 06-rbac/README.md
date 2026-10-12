# Exercise 6 · Least privilege with RBAC (advanced)

**Goal:** give an app or CI pipeline its own identity with only the permissions it needs.

**Concepts:** ServiceAccount, Role, RoleBinding, ClusterRole, `kubectl auth can-i`

## Steps

1. **Create** the `shop` namespace, a `ci` ServiceAccount, a Role that can only read Pods,
   and a RoleBinding. Read `rbac.yaml` first.

   ```sh
   kubectl apply -f rbac.yaml
   ```

   The same thing, imperatively:

   ```sh
   kubectl create ns shop
   kubectl create sa ci -n shop
   kubectl create role pod-reader -n shop --verb=get,list,watch --resource=pods
   kubectl create rolebinding ci-pods -n shop --role=pod-reader --serviceaccount=shop:ci
   ```

2. **Check permissions** by impersonating the ServiceAccount.

   ```sh
   A=system:serviceaccount:shop:ci
   kubectl auth can-i list pods    -n shop    --as=$A   # yes
   kubectl auth can-i delete pods  -n shop    --as=$A   # no
   kubectl auth can-i list secrets -n shop    --as=$A   # no
   kubectl auth can-i list pods    -n default --as=$A   # no: a Role is per namespace
   kubectl auth can-i --list -n shop --as=$A
   ```

3. **Use the identity for real.** This Pod runs as `ci` and calls the API with its
   mounted token.

   ```sh
   kubectl apply -f api-client-pod.yaml
   kubectl logs -n shop api-client
   ```

4. **Challenge:** let `ci` read Pod logs too. Two ways:
   - add `pods/log` to the Role's resources, or
   - bind the built-in `view` ClusterRole in the namespace:
     `kubectl create rolebinding ci-view -n shop --clusterrole=view --serviceaccount=shop:ci`

   Check with `kubectl auth can-i get pods/log -n shop --as=$A`.

<details>
<summary>What you should see</summary>

- Step 2: yes / no / no / no. RBAC is deny-by-default and a Role only applies in its namespace.
- Step 3: `list pods -> HTTP 200` and `list secrets -> HTTP 403`.
- Step 4: `yes`. Note that `view` deliberately does not include Secrets.

</details>

## Clean up

```sh
kubectl delete ns shop
```
