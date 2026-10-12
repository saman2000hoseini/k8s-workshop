# Exercise 1 · Deploy, break, heal, roll back

**Goal:** see the desired-state loop in action: Kubernetes keeps your app running,
updates it safely, and lets you roll back.

**Concepts:** Pod, ReplicaSet, Deployment, labels, rolling update, readiness probe

## Steps

1. **Deploy** nginx with 3 replicas and watch the Pods start.

   ```sh
   kubectl apply -f deployment.yaml
   kubectl get pods -l app=web -w        # Ctrl+C to stop watching
   ```

   Prefer the imperative way? `kubectl create deployment web --image=nginx:1.27 --replicas=3`

2. **Break a Pod:** delete one and watch the ReplicaSet replace it.

   ```sh
   kubectl delete pod <one-of-the-web-pods>
   kubectl get pods -l app=web
   ```

3. **Scale** to 5 replicas.

   ```sh
   kubectl scale deploy/web --replicas=5
   ```

4. **Ship a broken version:** update to an image tag that doesn't exist.

   ```sh
   kubectl set image deploy/web nginx=nginx:nope
   kubectl rollout status deploy/web     # hangs: Ctrl+C
   kubectl get pods -l app=web
   ```

   ❓ What status do the new Pods have? Is the old version still serving?

5. **Roll back** and look at the history.

   ```sh
   kubectl rollout undo deploy/web
   kubectl rollout history deploy/web
   ```

<details>
<summary>What you should see</summary>

- Step 2: a new Pod with a new name appears within seconds; there are always 3.
- Step 4: one new Pod in `ImagePullBackOff`. Because `deployment.yaml` sets
  `maxUnavailable: 0` and a readiness probe, all 5 old Pods keep serving.
  The rollout simply stops.
- Step 5: the Deployment goes back to the previous ReplicaSet; the broken Pod disappears.

</details>

## Bonus

- `kubectl describe pod <broken-pod>` and read the **Events** at the bottom.
- Change `maxUnavailable` to `25%`, re-apply, and repeat step 4. What's different?
