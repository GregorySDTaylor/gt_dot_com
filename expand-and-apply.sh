#!/bin/bash
./expand-templates.sh
namespace=`cat target/text/namespace`
kubectl apply -f target/k8s/namespace.yaml
helm upgrade --install -f target/helm/certManager.yaml cert-manager jetstack/cert-manager --namespace "$namespace"
# manually define cloudflare-dns01-token secret
# kubectl create secret generic cloudflare-dns01-token --from-literal=api-token='token here' -n 'namespace here'
kubectl apply -f target/k8s/resources.yaml
helm upgrade --install -f target/helm/vault.yaml vault hashicorp/vault --namespace "$namespace"
# manually initialize and unseal vault
# https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-raft#install-the-vault-helm-chart