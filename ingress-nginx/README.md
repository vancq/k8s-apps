# Ingress NGINX Controller

NGINX Ingress Controller deployed via ArgoCD using Helm chart.

## Deployment

Deploy to ArgoCD:
```bash
kubectl apply -f argocd-application.yaml
```

## Verify Installation

Check ingress controller pods:
```bash
kubectl get pods -n ingress-nginx
```

Check ingress controller service:
```bash
kubectl get svc -n ingress-nginx
```

## Port-Forward

To access ingress controller locally:
```bash
kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 8080:80
```

## Configuration

- **Namespace**: ingress-nginx
- **Chart Version**: 4.9.0
- **Service Type**: LoadBalancer
- **Default Ingress Class**: true
