# Solutions

No peeking until time is up.

## c1 · Stuck in Pending

The Pods request `cpu: "64"`: 64 whole CPUs. No node has that much, so the scheduler leaves them
`Pending` (Events: `Insufficient cpu`). Lower the request:

```sh
kubectl set resources deploy/api -n c1 --requests=cpu=100m,memory=64Mi
```

**Lesson:** requests are a reservation the scheduler must find room for. `describe` → Events.

## c2 · Missing greeting

The Pod is stuck in `CreateContainerConfigError`: the env var references key `greeting`, but the
ConfigMap key is `GREETING`. Fix the reference:

```sh
kubectl patch deploy greeter -n c2 --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/containers/0/env/0/valueFrom/configMapKeyRef/key","value":"GREETING"}]'
```

**Lesson:** a missing ConfigMap or key stops the container from being created. Keys are case-sensitive.

## c3 · Connection refused

The Service sends traffic to `targetPort: 8080`, but nginx listens on `80`. The selector is fine,
so the EndpointSlice has Pod IPs, but every connection is refused.

```sh
kubectl patch svc shop -n c3 --type=json -p '[{"op":"replace","path":"/spec/ports/0/targetPort","value":80}]'
```

**Lesson:** `port` is what clients use; `targetPort` must match the container port.

## c4 · Running but never Ready

The readiness probe checks `/healthz`, which nginx doesn't serve (404), so the Pods never become
Ready and are left out of the Service. Point the probe at a path that exists:

```sh
kubectl patch deploy web -n c4 --type=json \
  -p '[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/"}]'
```

**Lesson:** not Ready = no traffic, but no restart. In your own apps, expose a real `/readyz`.

## c5 · Locked out

The allow policy expects `role: frontend`, but the frontend Pods are labelled `app: frontend`.
Fix the policy (or add the label to the frontend's Pod template):

```sh
kubectl patch networkpolicy api-from-frontend -n c5 --type=json \
  -p '[{"op":"replace","path":"/spec/ingress/0/from/0/podSelector/matchLabels","value":{"app":"frontend"}}]'
```

**Lesson:** NetworkPolicies, like Services, are only as good as their label selectors.

## c6 · Forbidden

Two mistakes:

1. The Role grants `deployments` in the core group `""`. Deployments live in `apps`.
2. The RoleBinding's subject is `deploy-bot`, not `deployer`.

```sh
kubectl patch role deployer -n c6 --type=json -p '[{"op":"replace","path":"/rules/0/apiGroups","value":["apps"]}]'
kubectl patch rolebinding deployer -n c6 --type=json -p '[{"op":"replace","path":"/subjects/0/name","value":"deployer"}]'
```

**Lesson:** check both halves of RBAC: what is allowed (Role) and who gets it (RoleBinding).
`kubectl auth can-i --as` is the fastest test.

## c7 · The autoscaler is blind

The Deployment sets no CPU request. Utilization is measured as a percentage of the request, so the
HPA can't compute it. Depending on the version, `describe hpa` says `missing request for cpu` or only
the vague `did not receive metrics for targeted pods`: knowing the rule beats reading the error.

```sh
kubectl set resources deploy/web -n c7 --requests=cpu=100m,memory=64Mi --limits=memory=128Mi
```

After about a minute `kubectl get hpa -n c7` shows a percentage.

**Lesson:** no requests, no autoscaling. And metrics-server must be running.
