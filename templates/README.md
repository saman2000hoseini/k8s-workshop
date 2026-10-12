# Templates

Starting points for your own manifests. Copy one, rename `my-app`, adjust, and apply.

| File | What |
|---|---|
| `pod.yaml` | A single Pod (mostly for experiments) |
| `deployment.yaml` | Production-style Deployment: probes, resources, security context, config |
| `service.yaml` | ClusterIP Service |
| `service-external.yaml` | ExternalName and custom-endpoint Services for things outside the cluster |
| `configmap-secret.yaml` | ConfigMap and Secret |
| `ingress.yaml` | Ingress with host routing and TLS |
| `gateway-httproute.yaml` | Gateway API HTTPRoute with a 90/10 canary |
| `pvc.yaml` | PersistentVolumeClaim |
| `statefulset.yaml` | Headless Service + StatefulSet with per-Pod storage |
| `job-cronjob.yaml` | Job and CronJob |
| `daemonset.yaml` | DaemonSet (one Pod per node) |
| `static-pod.yaml` | Static Pod run by the kubelet from `/etc/kubernetes/manifests` |
| `hpa.yaml` | HorizontalPodAutoscaler |
| `networkpolicy.yaml` | Default deny + one allow rule |
| `serviceaccount-rbac.yaml` | ServiceAccount, Role, RoleBinding, and binding a built-in ClusterRole |
| `namespace-quota.yaml` | Namespace with Pod Security, ResourceQuota and LimitRange |

Check a file without creating anything:

```sh
kubectl apply --dry-run=server -f deployment.yaml
```

Generate a fresh skeleton for almost any resource:

```sh
kubectl create deployment my-app --image=nginx:1.27 --dry-run=client -o yaml > my-app.yaml
kubectl explain deployment.spec.strategy        # field documentation in the terminal
```
