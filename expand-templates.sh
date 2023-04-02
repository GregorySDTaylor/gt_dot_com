#!/bin/bash
mkdir -p target/text
dhall text --file ./infrastructure/k8s/namespaceText.dhall > target/text/namespace

mkdir -p target/k8s
dhall-to-yaml --file infrastructure/k8s/namespaceForExport.dhall > target/k8s/namespace.yaml

mkdir -p target/helm
dhall-to-yaml --file infrastructure/helm/certManager.dhall > target/helm/certManager.yaml
dhall-to-yaml --file infrastructure/helm/vault.dhall > target/helm/vault.yaml

dhall-to-yaml --documents --file infrastructure/k8s/resourcesForExport.dhall > target/k8s/resources.yaml
