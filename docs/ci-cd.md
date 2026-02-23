# CI/CD & GitOps

## CI/CD
- GitHub Actions workflow in .github/workflows/
- Terraform plan on PR, apply on merge (optional)
- Kubernetes manifest validation and policy checks

## GitOps (ArgoCD)
- argocd/root-app.yaml uses app-of-apps pattern
- apps reference k8s/ and helm-values/

