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

echo "Setting image using kustomize"
cd k8s/overlays/prod
kustomize edit set image pranavpatildevops/eks-app="$IMAGE"

echo "Applying Kubernetes manifests"
kubectl apply -k .

cd "$WORKDIR"
echo "Applying Ingress"
kubectl apply -f k8s/ingress.yaml

echo "Waiting for rollout to complete..."
kubectl rollout status deployment/prod-eks-app

echo "Deployment successful: $IMAGE"

