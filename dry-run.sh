#!/bin/bash
mkdir -p target
dhall-to-yaml --documents --file infrastructure/k8s/resources.dhall > target/k8s-resources.yaml