#!/bin/bash
./expand-templates.sh
# TODO extract namespace?
kubectl apply -f target/k8s/namespace.yaml
helm upgrade --install -f target/helm/certManager.yaml cert-manager jetstack/cert-manager --namespace gt-homelab
# manually define cloudflare-dns01-token secret
# kubectl create secret generic cloudflare-dns01-token --from-literal=api-token='token here' -n gt-homelab
kubectl apply -f target/k8s/resources.yaml
helm upgrade --install -f target/helm/vault.yaml vault hashicorp/vault --namespace gt-homelab
# manually initialize and unseal vault
# https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-raft#install-the-vault-helm-chart