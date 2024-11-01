#!/bin/bash
tree
kustomize build overlays/dev | kubectl apply -f -
kustomize build overlays/prod | kubectl apply -f -
#See the base customize build without applying: kustomize build base/
#Delete everything: kustomize build overlays/dev | kubectl delete -f - && kustomize build overlays/prod | kubectl delete -f -