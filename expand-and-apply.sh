#!/bin/bash
./expand-templates.sh
# TODO extract namespace?
kubectl apply -f target/k8s/namespace.yaml
helm upgrade --install -f target/helm/certManager.yaml cert-manager jetstack/cert-manager --namespace gt-homelab
# manually define cloudflare-dns01-token secret
kubectl apply -f target/k8s/resources.yaml
helm upgrade --install -f target/helm/vault.yaml vault hashicorp/vault --namespace gt-homelab
# manually initialize and unseal vault
