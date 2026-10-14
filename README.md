# Kubernetes Fundamentals · Workshop materials

Linux Fest 2026 · Saman Hoseini

Everything you need for the hands-on parts of the workshop: setup instructions,
six exercises with ready-to-use manifests, and templates to start your own projects.

```sh
git clone https://github.com/saman2000hoseini/k8s-workshop.git
cd k8s-workshop
```

No git? Use **Code → Download ZIP** on GitHub. The slides are in [`slides`](slides/).

## How the day works

1. **Part 1 · Concepts.** No laptop needed.
2. **Break & cluster setup.** Follow [`00-setup`](00-setup/README.md) and run `./00-setup/verify.sh`.
3. **Part 2 · Hands-on.** Exercises 1–3, then [challenge round 1](challenges/README.md) (c1–c4).
4. **Short break.**
5. **Part 3 · Advanced topics.** Exercises 4–6 (optional; also great for practice at home),
   then [challenge round 2](challenges/README.md) (c5–c7).

## Contents

| Folder | What you do |
|---|---|
| [`00-setup`](00-setup/README.md) | Install minikube, start the cluster, verify it |
| [`01-deploy-break-heal`](01-deploy-break-heal/README.md) | Deploy, delete Pods, scale, ship a broken version, roll back |
| [`02-config-and-state`](02-config-and-state/README.md) | ConfigMaps, Secrets, live config updates, StatefulSet storage |
| [`03-expose-and-discover`](03-expose-and-discover/README.md) | Services, DNS, port-forward, debug an empty Service |
| [`04-network-policy`](04-network-policy/README.md) | Default deny, label-based allow, custom endpoints |
| [`05-resources-and-autoscaling`](05-resources-and-autoscaling/README.md) | Requests/limits, QoS, metrics-server, HPA, OOMKilled |
| [`06-rbac`](06-rbac/README.md) | ServiceAccount, Role, RoleBinding, `kubectl auth can-i` |
| [`challenges`](challenges/README.md) | Timed fix-it challenges: something's broken, find it, `./check.sh` |
| [`templates`](templates/README.md) | Commented manifests to copy for your own apps |
| [`CHEATSHEET.md`](CHEATSHEET.md) | kubectl essentials and a debugging playbook |

Each exercise README has the steps, questions to think about, and a collapsed
**What you should see** section to check your results.

Run the exercises in order: 2–5 build on the `web` app from Exercise 1.
Everything runs in the `default` namespace except Exercise 6 (`shop`) and the challenges (`c1`–`c7`).

> **Safety first:** if your kubeconfig also contains work clusters, check
> `kubectl config current-context` before every exercise. It should be
> `minikube`.

## Clean up after the workshop

```sh
minikube delete
```
