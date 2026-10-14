#!/usr/bin/env sh
# Challenge 7 check: the HPA must be able to read CPU utilization.
NS=c7
fail() { echo "FAIL: $1"; exit 1; }
kubectl get ns $NS >/dev/null 2>&1 || fail "namespace $NS not found. Run: kubectl apply -f broken.yaml"
kubectl top nodes >/dev/null 2>&1 || fail "metrics-server isn't working. Run ../../05-resources-and-autoscaling/install-metrics-server.sh"
util=$(kubectl get hpa web -n $NS -o jsonpath='{.status.currentMetrics[0].resource.current.averageUtilization}')
[ -n "$util" ] || fail "the HPA still can't compute CPU utilization (TARGETS shows <unknown>). Fixed it? Metrics can take a minute: run me again"
echo "PASS: the HPA sees ${util}% CPU and can scale web"
