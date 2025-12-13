# Nginx Deployment with ArgoCD

## Prerequisites
1. Kubernetes cluster running
2. ArgoCD installed in the cluster
3. Git repository with this code

## Setup Steps

### 1. Install ArgoCD (if not already installed)
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 2. Access ArgoCD UI
```bash
# Port forward to access ArgoCD server
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Access at: https://localhost:8080
- Username: `admin`
- Password: (from command above)

### 3. Update Git Repository URL
Edit `argocd-application.yaml` and replace:
```yaml
repoURL: https://github.com/yourusername/yourrepo.git
```
With your actual Git repository URL.

### 4. Push to Git
```bash
git add .
git commit -m "Add nginx deployment"
git push origin main
```

### 5. Deploy the Application to ArgoCD
```bash
kubectl apply -f nginx/argocd-application.yaml
```

### 6. Verify Deployment
```bash
# Check ArgoCD application status
kubectl get applications -n argocd

# Check nginx deployment
kubectl get all -n dev
```

### 7. Access Nginx
```bash
kubectl port-forward -n dev svc/nginx 8080:80
```
Visit: http://localhost:8080

## How It Works

ArgoCD will:
- ✅ Monitor your Git repository for changes
- ✅ Automatically sync changes to the cluster
- ✅ Create the `dev` namespace if it doesn't exist
- ✅ Deploy nginx based on `deployment.yaml`
- ✅ Self-heal if someone manually modifies resources
- ✅ Prune resources deleted from Git

## Manual Sync (Optional)
```bash
# Sync via CLI
argocd app sync nginx

# Or use the ArgoCD UI
```

## Troubleshooting
```bash
# View application details
kubectl describe application nginx -n argocd

# View ArgoCD logs
kubectl logs -n argocd deployment/argocd-application-controller
```
