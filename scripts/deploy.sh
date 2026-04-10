#!/bin/bash
set -euo pipefail

DOCKERHUB_USER="pranavpatildevops"
TAG="${1:-latest}"
IMAGE="${DOCKERHUB_USER}/eks-app:${TAG}"

WORKDIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$WORKDIR"

echo "Building Docker image: $IMAGE"
docker build -t "$IMAGE" .

echo "Pushing Docker image to Docker Hub"
docker push "$IMAGE"

echo "Applying Kubernetes manifests"
kubectl apply -k k8s/base

if kubectl get deployment eks-app >/dev/null 2>&1; then
  echo "Updating deployment image to $IMAGE"
  kubectl set image deployment/eks-app eks-app="$IMAGE" --record
fi

kubectl apply -f k8s/ingress.yaml
kubectl rollout status deployment/eks-app

echo "Deployment successful: $IMAGE"
