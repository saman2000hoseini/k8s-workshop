# Exercise 3 · Expose and discover

**Goal:** give your Pods a stable name and address, reach them by DNS, and debug the
most common Service bug.

**Concepts:** Service (ClusterIP), Endpoints, DNS, port-forward

Needs the `web` Deployment from Exercise 1 or 2.

## Steps

1. **Expose** the Deployment.

   ```sh
   kubectl apply -f service.yaml          # or: kubectl expose deploy/web --port=80
   kubectl get svc,endpoints
   ```

2. **Reach it by DNS** from a throwaway Pod.

   ```sh
   kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never -- wget -qO- http://web
   kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never -- \
     wget -qO- http://web.default.svc.cluster.local
   ```

3. **Reach it from your laptop.**

   ```sh
   kubectl port-forward svc/web 8080:80
   # open http://localhost:8080, Ctrl+C to stop
   ```

4. **Break it:** point the selector at labels no Pod has.

   ```sh
   kubectl patch svc web -p '{"spec":{"selector":{"app":"nope"}}}'
   kubectl get endpoints web
   kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never -- wget -T 3 -qO- http://web
   ```

   ❓ What happened to the endpoints? Now fix it:

   ```sh
   kubectl patch svc web -p '{"spec":{"selector":{"app":"web"}}}'
   ```

<details>
<summary>What you should see</summary>

- Steps 2–3: the nginx welcome page.
- Step 4: the Endpoints show `<none>` and `wget` fails with
  `Connection refused`. The Service exists, but nothing matches its selector.
  This is the most common "my Service doesn't work" bug.
- kubectl prints `Warning: v1 Endpoints is deprecated in v1.33+`. That's expected;
  the slide "From Endpoints to EndpointSlices" explains it.

</details>

> busybox's `nslookup` doesn't use search domains well; use full names like
> `web.default.svc.cluster.local` with it.
