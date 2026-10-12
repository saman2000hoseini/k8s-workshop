#!/usr/bin/env sh
# Checks that your local cluster is ready for the workshop.
set -e

echo "==> kubectl client"
kubectl version --client

echo "==> Current context: $(kubectl config current-context)"

echo "==> Nodes"
kubectl get nodes
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "==> Starting a test Pod"
kubectl run hello --image=nginx:1.27 --restart=Never
kubectl wait --for=condition=Ready pod/hello --timeout=180s
kubectl get pod hello
kubectl delete pod hello --wait=false

echo
echo "All good: your cluster is ready."
