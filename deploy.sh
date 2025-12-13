#!/bin/bash

# ArgoCD Deployment Script for Infrastructure Services
# This script deploys all infrastructure services to ArgoCD

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if kubectl can access the cluster
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster. Please check your kubeconfig."
    exit 1
fi

# Check if ArgoCD namespace exists
if ! kubectl get namespace argocd &> /dev/null; then
    print_error "ArgoCD namespace not found. Please install ArgoCD first."
    exit 1
fi

print_info "Starting deployment of applications to ArgoCD..."

# Deploy nginx application to ArgoCD
print_info "Deploying Nginx application to ArgoCD..."
kubectl apply -f nginx/argocd-application.yaml

print_info "All applications deployed to ArgoCD successfully!"

# Wait for application to be synced
print_info "Waiting for nginx application to sync..."
sleep 5

# Display ArgoCD application status
print_info "ArgoCD Application Status:"
kubectl get application -n argocd

echo ""
print_info "Deployment completed!"
echo ""
print_info "To check application sync status:"
echo "  kubectl get application nginx -n argocd"
echo ""
print_info "To access nginx after it's synced, use port-forwarding:"
echo "  kubectl port-forward -n dev svc/nginx 8080:80"
echo ""

