#!/bin/bash

# Kubernetes Cleanup Script for Infrastructure Services
# This script removes all infrastructure services from Kubernetes

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

# Confirm deletion
print_warning "This will delete all infrastructure services and their data!"
read -p "Are you sure you want to continue? (yes/no): " confirmation

if [ "$confirmation" != "yes" ]; then
    print_info "Cleanup cancelled."
    exit 0
fi

print_info "Starting cleanup of infrastructure services..."

# Ask about namespace deletion
echo ""
read -p "Do you want to delete the namespace 'dev'? This will remove any remaining resources. (yes/no): " delete_ns

if [ "$delete_ns" == "yes" ]; then
    print_info "Deleting namespace..."
    kubectl delete namespace dev --ignore-not-found=true
    print_info "Namespace deleted."
else
    print_info "Namespace 'dev' preserved."
fi

print_info "Cleanup completed!"

