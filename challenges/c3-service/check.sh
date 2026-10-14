#!/usr/bin/env sh
# Challenge 3 check: http://shop.c3 must return the nginx page from inside the cluster.
NS=c3
fail() { echo "FAIL: $1"; exit 1; }
kubectl get ns $NS >/dev/null 2>&1 || fail "namespace $NS not found. Run: kubectl apply -f broken.yaml"
out=$(kubectl run check-c3 -n $NS --rm -i --quiet --restart=Never --image=busybox:1.37 -- \
  wget -T 3 -qO- http://shop.c3 2>&1)
echo "$out" | grep -q "Welcome to nginx" || fail "http://shop.c3 doesn't answer: $(echo "$out" | head -1)"
echo "PASS: the shop Service reaches the nginx Pods"
