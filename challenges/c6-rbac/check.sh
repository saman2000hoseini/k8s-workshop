#!/usr/bin/env sh
# Challenge 6 check: deployer may manage Deployments in c6, and nothing more.
NS=c6
SA=system:serviceaccount:c6:deployer
fail() { echo "FAIL: $1"; exit 1; }
kubectl get ns $NS >/dev/null 2>&1 || fail "namespace $NS not found. Run: kubectl apply -f broken.yaml"
can() { [ "$(kubectl auth can-i "$@" --as=$SA 2>/dev/null)" = "yes" ]; }
can create deployments.apps -n $NS || fail "deployer can't create Deployments in c6"
can update deployments.apps -n $NS || fail "deployer can't update Deployments in c6"
can delete deployments.apps -n $NS && fail "deployer can delete Deployments. Too much"
can get secrets -n $NS && fail "deployer can read Secrets. Too much"
can create deployments.apps -n default && fail "deployer can create Deployments outside c6. Too much"
echo "PASS: deployer can manage Deployments in c6 and nothing more"
