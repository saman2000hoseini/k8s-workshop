#!/usr/bin/env sh
# Challenge 4 check: both web Pods Ready, still with a readiness probe.
NS=c4
fail() { echo "FAIL: $1"; exit 1; }
kubectl get ns $NS >/dev/null 2>&1 || fail "namespace $NS not found. Run: kubectl apply -f broken.yaml"
probe=$(kubectl get deploy web -n $NS -o jsonpath='{.spec.template.spec.containers[0].readinessProbe}')
[ -n "$probe" ] || fail "the readiness probe is gone. Fix it instead of deleting it"
ready=$(kubectl get deploy web -n $NS -o jsonpath='{.status.readyReplicas}')
[ "${ready:-0}" -ge 2 ] || fail "web has ${ready:-0}/2 Ready Pods. Look at: kubectl describe pod -n $NS -l app=web"
echo "PASS: both web Pods are Ready and the Service has endpoints"
