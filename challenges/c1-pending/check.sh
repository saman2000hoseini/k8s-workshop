#!/usr/bin/env sh
# Challenge 1 check: both api Pods must be Running and Ready.
NS=c1
fail() { echo "FAIL: $1"; exit 1; }
kubectl get ns $NS >/dev/null 2>&1 || fail "namespace $NS not found. Run: kubectl apply -f broken.yaml"
ready=$(kubectl get deploy api -n $NS -o jsonpath='{.status.readyReplicas}')
[ "${ready:-0}" -ge 2 ] || fail "api has ${ready:-0}/2 ready Pods. Look at: kubectl get pods -n $NS"
cpu=$(kubectl get deploy api -n $NS -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')
[ -n "$cpu" ] || fail "the CPU request is gone. Keep a request, just make it realistic"
echo "PASS: both api Pods are running (CPU request: $cpu)"
