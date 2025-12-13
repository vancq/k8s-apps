# Demo Service

Spring Boot application deployed via ArgoCD.

## Deployment

Deploy to ArgoCD:
```bash
kubectl apply -f argocd-application.yaml
```

## Access

Port-forward to access the service:
```bash
kubectl port-forward -n dev service/demo-service 8080:8080
```

Then access: http://localhost:8080

## Configuration

- **Namespace**: dev
- **Port**: 8080
- **Replicas**: 1
- **Image**: openjdk:17-jdk-slim (placeholder - replace with your Spring Boot app image)
