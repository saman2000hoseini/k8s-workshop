# Exercise 4 · Lock it down (advanced)

**Goal:** restrict traffic between Pods, and give an outside system an in-cluster name.

**Concepts:** NetworkPolicy, default deny, label-based allow, Service without a selector, EndpointSlice

Needs the `web` Deployment and Service from the earlier exercises.
NetworkPolicies are enforced by the network plugin. On minikube they only work if you
started the cluster with `--cni=cilium` (see [00-setup](../00-setup/README.md)).

## Steps

1. **Deny all ingress** traffic in the namespace.

   ```sh
   kubectl apply -f default-deny.yaml
   ```

2. **Test:** this should now time out.

   ```sh
   kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never -- wget -T 3 -qO- http://web
   ```

3. **Allow only Pods labelled `access=true`.** Try writing the policy yourself first
   (start from the NetworkPolicy slide), then compare with `allow-access-label.yaml`.

   ```sh
   kubectl apply -f allow-access-label.yaml
   kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never -- wget -T 3 -qO- http://web
   kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never --labels=access=true -- \
     wget -T 3 -qO- http://web
   ```

4. **Challenge: custom endpoints.** Create a Service with no selector and an
   EndpointSlice that points at an IP outside the cluster.

   ```sh
   kubectl apply -f external-service.yaml
   kubectl get svc outside
   kubectl get endpointslices -l kubernetes.io/service-name=outside
   kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never -- \
     sh -c 'wget -S -T 5 -O /dev/null http://outside 2>&1 | head -3'
   ```

<details>
<summary>What you should see</summary>

- Step 2: `wget: download timed out`.
- Step 3: without the label it times out; with `access=true` you get the nginx page.
- Step 4: any HTTP response (even `403 Forbidden` or `301`) proves the request reached
  the outside IP through the Service. Edit the address in `external-service.yaml` to
  point at a machine on your own network.

</details>

## Clean up

```sh
kubectl delete -f default-deny.yaml -f allow-access-label.yaml -f external-service.yaml
```
