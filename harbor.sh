#!/bin/bash
#helm install
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

sleep 5

# ingress-controller

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz

sleep 5

# repo 등록
helm repo add harbor https://helm.goharbor.io

# 압축파일 다운로드
helm fetch harbor/harbor --untar

# namespace 생성
kubectl create ns harbor

# env
sed -i 's/core.harbor.domain/harbor.k-tech.cloud/g' ~/harbor/values.yaml
sed -i 's/className: ""/className: "nginx"/g' ~/harbor/values.yaml

sleep 5

# harbor deploy
helm install harbor -f ~/harbor/values.yaml ~/harbor/. -n harbor
