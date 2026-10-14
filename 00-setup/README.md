# 00 · Install a local Kubernetes cluster with minikube

You need three things on your laptop:

1. **A container engine**: Docker Desktop, OrbStack (macOS), Podman, or Docker Engine (Linux)
2. **minikube**: runs a real single-node Kubernetes cluster in a container or a VM
3. **kubectl**: the Kubernetes command-line client

Give your container engine at least **4 GB of RAM** and 2 CPUs.

The first `minikube start --cni=cilium` downloads about 1.5 GB (Kubernetes plus the Cilium
network plugin), so start it as soon as the setup break begins. The node stays `NotReady`
until Cilium is up; that's normal. After the workshop, `minikube stop` keeps everything and
the next start takes seconds.

---

## Install

### macOS

```sh
brew install minikube        # Homebrew installs kubectl with it
```

### Windows (PowerShell)

```powershell
winget install Kubernetes.minikube
winget install Kubernetes.kubectl
```

Run the `.sh` scripts in this folder from **Git Bash** or **WSL**.

### Linux (x86_64)

```sh
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

On ARM, use `minikube-linux-arm64`. For kubectl, either install it:

```sh
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -m 0755 kubectl /usr/local/bin/kubectl
```

or use the one bundled with minikube:

```sh
alias kubectl="minikube kubectl --"
```

---

## Start the workshop cluster

```sh
minikube start --cni=cilium   # Cilium so NetworkPolicies are enforced (Exercise 4)
kubectl get nodes             # minikube   Ready   control-plane
```

Low on memory? `minikube start --cni=cilium --memory=3000`

### Useful minikube commands

```sh
minikube status
minikube dashboard            # web UI
minikube addons list          # ingress, metrics-server, ...
minikube service web --url    # reach a Service from your laptop
minikube image load myapp:dev # copy a local image into the cluster
minikube stop                 # pause the cluster, keep its state
minikube delete               # remove everything
```

---

## Check your cluster

```sh
./verify.sh
```

It checks that the node is `Ready` and that a test Pod can start. You should see
`All good: your cluster is ready.`

> **Already have work clusters in your kubeconfig?** minikube switches your current
> context to the new cluster. Always check with `kubectl config current-context` before
> running exercises: it should say `minikube`.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `Cannot connect to the Docker daemon` / no driver found | Start Docker Desktop / OrbStack / Podman first |
| An old minikube cluster won't start | `minikube delete`, then `minikube start --cni=cilium` again |
| Node stays `NotReady` | Cilium is still downloading (can take several minutes on slow Wi-Fi); watch `kubectl get pods -n kube-system` |
| Not enough memory | `--memory=3000`; close other apps; give Docker 4 GB+ |
| NetworkPolicies have no effect | Cluster started without Cilium: `minikube delete` and start with `--cni=cilium` |
| `ImagePullBackOff` | Your network can't reach the registry. See *Restricted networks* below |
| Commands go to the wrong cluster | `kubectl config use-context minikube` |

### Restricted networks

Some networks block Google-hosted registries (`registry.k8s.io`, `gcr.io`) with
**HTTP 403**, while Docker Hub still works. This workshop is designed around that:

- **minikube** still starts: it falls back to Docker Hub for its base image and downloads
  a preload of the core images from GitHub.
- Exercises only use Docker Hub images (`nginx`, `busybox`, `curlimages/curl`).
- `05-resources-and-autoscaling/install-metrics-server.sh` enables the metrics-server
  addon from a Docker Hub mirror.

Slow Wi-Fi? The exercise images can also be pulled on your laptop and copied into minikube:

```sh
for i in nginx:1.27 busybox:1.37 curlimages/curl:8.16.0; do
  docker pull $i && minikube image load $i
done
```
