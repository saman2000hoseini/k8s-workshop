# Challenge 3 · Connection refused

**Round 1** · Suggested time limit: 5 minutes

The `shop` Pods are running and healthy, but nobody can reach them through the `shop` Service.

```sh
kubectl apply -f broken.yaml
kubectl run tmp -n c3 --rm -it --image=busybox:1.37 --restart=Never -- wget -T 3 -qO- http://shop
```

**Goal:** `http://shop.c3` returns the nginx welcome page.

```sh
./check.sh
```

<details>
<summary>Hint</summary>

This time the selector is fine: `kubectl get endpoints -n c3` lists the Pod IPs.
Look at the ports: what does the Service send traffic to, and what does the container listen on?

</details>
