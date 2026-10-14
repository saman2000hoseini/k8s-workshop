#!/usr/bin/env sh
# Challenge 2 check: greeter must run and print the greeting from the ConfigMap.
NS=c2
fail() { echo "FAIL: $1"; exit 1; }
kubectl get ns $NS >/dev/null 2>&1 || fail "namespace $NS not found. Run: kubectl apply -f broken.yaml"
ready=$(kubectl get deploy greeter -n $NS -o jsonpath='{.status.readyReplicas}')
[ "${ready:-0}" -ge 1 ] || fail "greeter is not running yet. Look at: kubectl get pods -n $NS"
kubectl logs deploy/greeter -n $NS 2>/dev/null | grep -q "Hello from Kubernetes" \
  || fail "greeter runs but doesn't print the ConfigMap's greeting. Did you hard-code a value?"
echo "PASS: greeter prints the greeting from the ConfigMap"
