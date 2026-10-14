#!/usr/bin/env sh
# Challenge 5 check: frontend reaches api; any other Pod is still blocked.
NS=c5
fail() { echo "FAIL: $1"; exit 1; }
kubectl get ns $NS >/dev/null 2>&1 || fail "namespace $NS not found. Run: kubectl apply -f broken.yaml"
kubectl get networkpolicy default-deny -n $NS >/dev/null 2>&1 || fail "default-deny was deleted. Keep it: only frontend may reach api"
kubectl rollout status deploy/frontend -n $NS --timeout=60s >/dev/null 2>&1 || fail "frontend is not running"
kubectl exec deploy/frontend -n $NS -- wget -T 3 -qO- http://api 2>/dev/null | grep -q "Welcome to nginx" \
  || fail "frontend can't reach http://api"
if kubectl run check-c5 -n $NS --rm -i --quiet --restart=Never --image=busybox:1.37 -- \
  wget -T 3 -qO- http://api 2>/dev/null | grep -q "Welcome to nginx"; then
  fail "a random Pod can reach api too. Only frontend should"
fi
echo "PASS: frontend reaches api, everyone else is blocked"
