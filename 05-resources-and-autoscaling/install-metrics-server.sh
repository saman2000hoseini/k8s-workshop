#!/usr/bin/env sh
# Enables the minikube metrics-server addon (needed for kubectl top and the HPA).
#
# The official image lives on registry.k8s.io. Some networks can't reach it
# (HTTP 403), so this script uses Rancher's mirror on Docker Hub.
# On an open network the plain command works too:
#   minikube addons enable metrics-server
set -e

minikube addons enable metrics-server \
  --images=MetricsServer=rancher/mirrored-metrics-server:v0.8.1 \
  --registries=MetricsServer=docker.io
kubectl -n kube-system rollout status deployment/metrics-server --timeout=180s

echo "Waiting for the first metrics (up to two minutes)..."
for i in $(seq 1 24); do
  kubectl top nodes >/dev/null 2>&1 && break
  sleep 5
done
kubectl top nodes
