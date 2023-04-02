#!/bin/bash
kubectl delete pods,services,certificates,secrets,issuers,clusterissuers -l "gregorysdtaylor.com/version=0.1.0-1" # TODO extract?