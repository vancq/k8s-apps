#!/bin/bash

# Kubernetes Deployment Script for Infrastructure Services
# This script deploys all infrastructure services to Kubernetes

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

print_info "Starting deployment of infrastructure services..."

# Create namespace
print_info "Creating namespace..."
kubectl apply -f namespace.yaml

# Wait a bit for namespace to be ready
sleep 2

# Deploy nginx
print_info "Deploying Nginx..."
kubectl apply -f nginx/deployment.yaml

print_info "All services deployed successfully!"

# Wait for all deployments to be ready
print_info "Waiting for all deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment --all -n dev || print_warning "Some deployments may still be starting..."

# Display status
print_info "Deployment Status:"
kubectl get all -n dev

print_info "PersistentVolumeClaims:"
kubectl get pvc -n dev

echo ""
print_info "Deployment completed!"
echo ""
print_info "To access nginx, use port-forwarding:"
echo "  kubectl port-forward -n dev svc/nginx 8080:80"
echo ""

