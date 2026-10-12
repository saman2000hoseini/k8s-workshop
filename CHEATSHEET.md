# kubectl cheat sheet

```sh
alias k=kubectl                        # save typing
source <(kubectl completion zsh)       # or bash
```

## Everyday commands

| Task | Command |
|---|---|
| List things | `kubectl get pods -o wide` · `-A` all namespaces · `-w` watch · `-l app=web` by label |
| Details + Events | `kubectl describe pod <pod>` |
| Apply YAML | `kubectl apply -f file.yaml` (or a folder: `-f k8s/`) |
| Delete what you applied | `kubectl delete -f file.yaml` |
| Logs | `kubectl logs deploy/web -f` · `--previous` for the last crash · `-c <container>` |
| Shell into a container | `kubectl exec -it <pod> -- sh` |
| Debug container | `kubectl debug -it <pod> --image=busybox:1.37 --target=<container>` |
| Reach a Service locally | `kubectl port-forward svc/web 8080:80` |
| Throwaway test Pod | `kubectl run tmp --rm -it --image=busybox:1.37 --restart=Never -- sh` |
| Scale | `kubectl scale deploy/web --replicas=5` |
| Update image | `kubectl set image deploy/web nginx=nginx:1.28` |
| Rollout | `kubectl rollout status\|history\|undo\|restart deploy/web` |
| Resource usage | `kubectl top pods` · `kubectl top nodes` (needs metrics-server) |
| Events, newest last | `kubectl get events --sort-by=.lastTimestamp` |
| Field docs | `kubectl explain deployment.spec.template.spec.containers` |
| Generate YAML | `kubectl create deployment web --image=nginx:1.27 --dry-run=client -o yaml` |
| Permissions | `kubectl auth can-i list pods --as=system:serviceaccount:<ns>:<sa>` |
| Who am I | `kubectl auth whoami` |
| Switch namespace | `kubectl config set-context --current --namespace=shop` |
| Which cluster? | `kubectl config current-context` |

## Debugging playbook

**get → describe (read the Events) → logs → exec / debug**

| Symptom | Likely cause | First command |
|---|---|---|
| `Pending` | No node fits: requests too big, taints, unbound PVC | `kubectl describe pod <pod>` → Events |
| `ImagePullBackOff` | Wrong image/tag, private registry, blocked registry | `kubectl describe pod <pod>` |
| `CrashLoopBackOff` | App exits on start: bad config, missing env, dependency down | `kubectl logs <pod> --previous` |
| `OOMKilled` | Memory limit too low, or a leak | `kubectl describe pod <pod>` → Last State |
| Running, no traffic | Selector mismatch, readiness failing, wrong targetPort | `kubectl get endpointslices -l kubernetes.io/service-name=<svc>` |
| Works locally, not in cluster | DNS name, NetworkPolicy, missing Secret/ConfigMap | `kubectl debug -it <pod> --image=busybox:1.37` |
