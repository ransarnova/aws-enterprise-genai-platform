#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="$ROOT_DIR/infrastructure/environments/lab"

AWS_REGION="ap-south-1"
IMAGE_TAG="${1:?Usage: scripts/deploy-app.sh <image-tag>}"

ECR_REPOSITORY_URL="$(terraform -chdir="$TF_DIR" output -raw ecr_repository_url)"
KNOWLEDGE_BASE_ID="$(terraform -chdir="$TF_DIR" output -raw knowledge_base_id)"

REPOSITORY_NAME="${ECR_REPOSITORY_URL##*/}"

IMAGE_DIGEST="$(aws ecr describe-images \
  --region "$AWS_REGION" \
  --repository-name "$REPOSITORY_NAME" \
  --image-ids "imageTag=$IMAGE_TAG" \
  --query 'imageDetails[0].imageDigest' \
  --output text)"

if [[ -z "$IMAGE_DIGEST" || "$IMAGE_DIGEST" == "None" ]]; then
  echo "ERROR: Unable to resolve image digest for $IMAGE_TAG" >&2
  exit 1
fi

IMAGE_URI="$ECR_REPOSITORY_URL@$IMAGE_DIGEST"

echo "Deploying image: $IMAGE_URI"
echo "Knowledge Base ID: $KNOWLEDGE_BASE_ID"

kubectl apply -f "$ROOT_DIR/kubernetes/base/namespace.yaml"
kubectl apply -f "$ROOT_DIR/kubernetes/base/serviceaccount.yaml"

sed \
  -e "s|REPLACE_WITH_ECR_IMAGE_URI|$IMAGE_URI|g" \
  -e "s|REPLACE_WITH_KNOWLEDGE_BASE_ID|$KNOWLEDGE_BASE_ID|g" \
  "$ROOT_DIR/kubernetes/base/deployment.yaml" \
  | kubectl apply -f -

kubectl apply -f "$ROOT_DIR/kubernetes/base/service.yaml"

kubectl rollout status \
  deployment/genai-platform-api \
  -n genai-platform \
  --timeout=180s

kubectl get pods -n genai-platform -o wide
