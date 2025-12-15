# Gateway Service

Kubernetes manifests and ArgoCD application for the API Gateway service.

## Structure

```
gateway-service/
├── argocd-application.yaml    # ArgoCD Application definition
└── k8s/
    ├── deployment.yaml        # Deployment and Service
    └── ingress.yaml           # Ingress configuration
```

## Deployment

### Manual Deployment

```bash
kubectl apply -f k8s/
```

### ArgoCD Deployment

1. Update the `repoURL` in `argocd-application.yaml` with your Git repository
2. Apply the ArgoCD Application:

```bash
kubectl apply -f argocd-application.yaml
```

## Configuration

- **Replicas**: 2 pods for high availability
- **Port**: 8080 (HTTP)
- **Health checks**: Liveness and readiness probes configured
- **Resources**: 512Mi-1Gi memory, 250m-500m CPU
- **Ingress**: Accessible via `gateway.local` hostname

## Access

- Internal: `http://gateway-service:8080`
- External: `http://gateway.local` (via Ingress)

## ArgoCD Features

- Automated sync enabled
- Self-healing enabled
- Prune resources enabled
- Retry with exponential backoff
