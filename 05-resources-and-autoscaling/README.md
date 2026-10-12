# Exercise 5 · Right-size & autoscale (advanced)

**Goal:** set requests and limits, see QoS classes, autoscale on CPU, and watch a
container get OOMKilled.

**Concepts:** requests/limits, QoS, metrics-server, HorizontalPodAutoscaler, OOMKilled

Needs the `web` Deployment and Service from the earlier exercises.

## Steps

1. **Set requests and limits** and check the QoS class.

   ```sh
   kubectl set resources deploy/web --requests=cpu=100m,memory=64Mi --limits=memory=128Mi
   kubectl get pod -l app=web -o jsonpath='{.items[0].status.qosClass}'
   ```

2. **Install metrics-server** and look at real usage.

   ```sh
   ./install-metrics-server.sh          # enables the minikube addon
   kubectl top nodes
   kubectl top pods
   ```

3. **Autoscale** at 50% CPU and generate load.

   ```sh
   kubectl apply -f hpa.yaml            # or: kubectl autoscale deploy/web --cpu-percent=50 --min=1 --max=10
   kubectl apply -f load-generator.yaml
   kubectl get hpa,pods -w              # Ctrl+C to stop
   kubectl delete pod load              # stop the load and watch it scale down (takes ~5 min)
   ```

4. **Challenge: OOMKilled.** A container with a 32Mi limit that wants more.

   ```sh
   kubectl apply -f oom-demo.yaml
   kubectl get pod oom-demo -w
   kubectl describe pod oom-demo | grep -A3 "Last State"
   kubectl delete pod oom-demo
   ```

<details>
<summary>What you should see</summary>

- Step 1: `Burstable` (requests set, limits not equal to requests).
- Step 3: within a minute or two CPU goes above 50% and replicas grow (for example 2 → 3).
  Scale-down waits for a 5-minute stabilization window on purpose.
- Step 4: `OOMKilled`, then `CrashLoopBackOff` with growing restart delays.
  CPU over the limit is throttled; memory over the limit is killed.

</details>
