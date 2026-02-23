# Deployment Guide (Ubuntu 22.04.05)

This guide assumes a clean Ubuntu 22.04.05 LTS host with AWS credentials that have permissions for EKS, VPC, IAM, RDS, ElastiCache, EFS/EBS, WAF, and CloudFront.

## 1) Install Tools
Required:
- awscli v2
- kubectl
- helm v3
- terraform
- python3 + pip
- tutor (latest stable at deploy time)

Example install sequence:
```
sudo apt-get update
sudo apt-get install -y unzip jq python3-pip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Terraform (example)
sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform

# Tutor
python3 -m pip install --upgrade pip
python3 -m pip install "tutor[full]"
```

## 2) Configure AWS
```
aws configure
export AWS_REGION=<your-region>
```

## 3) Provision Infrastructure (Terraform)
Choose an environment:
- infra/terraform/envs/dev
- infra/terraform/envs/staging
- infra/terraform/envs/prod

Example:
```
cd infra/terraform/envs/prod
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

## 4) Configure kubectl Access
```
aws eks update-kubeconfig --region <region> --name <cluster_name>
```

## 5) Install Cluster Addons
```
# Nginx Ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  -n ingress-nginx --create-namespace \
  -f ../../../../helm-values/nginx-ingress-values.yaml

# Metrics Server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server -n kube-system

# EFS CSI
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm upgrade --install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver -n kube-system

# EBS CSI (for MongoDB/Elasticsearch PVCs)
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm upgrade --install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver -n kube-system

# Prometheus + Grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace \
  -f ../../../../helm-values/kube-prometheus-stack-values.yaml
```

## 6) Deploy In-Cluster Databases (MongoDB + Elasticsearch)
Apply DB namespace and storage classes:
```
kubectl apply -f ../../k8s/db/namespace.yaml
kubectl apply -f ../../k8s/storageclass-ebs-gp3.yaml
kubectl apply -f ../../k8s/volume-snapshotclass-ebs.yaml
kubectl apply -f ../../k8s/db/network-policy.yaml
```
Then follow docs/database-setup.md to install MongoDB and Elasticsearch via Helm (StatefulSets with PV/PVC).

## 7) Configure Tutor and Deploy OpenEdX
```
# Load base config (edit as needed)
cp ../../tutor/config.yml ~/.local/share/tutor/config.yml

# Set external service endpoints and secrets
python3 -m tutor config save --set RUN_E2E_TESTS=0
# Set MongoDB credentials from Helm secret and update MONGO_HOST to mongodb.openedx-db.svc.cluster.local

# Disable default Caddy (use Nginx Ingress instead)
# If your Tutor version uses different keys, update tutor/config.yml accordingly.
python3 -m tutor config save --set CADDY_ENABLED=0 --set ENABLE_HTTPS=0

# Build and deploy
bash ../../scripts/tutor-deploy.sh
```

## 8) Apply K8s Manifests
```
kubectl apply -f ../../k8s/namespace.yaml
kubectl apply -f ../../k8s/storageclass-efs.yaml
kubectl apply -f ../../k8s/pvc-openedx.yaml
kubectl apply -f ../../k8s/ingress-openedx.yaml
kubectl apply -f ../../k8s/hpa-lms.yaml
kubectl apply -f ../../k8s/hpa-cms.yaml
kubectl apply -f ../../k8s/resource-quota.yaml
kubectl apply -f ../../k8s/limit-range.yaml
```

Optional (dedicated Nginx reverse proxy instead of direct LMS/CMS ingress):
```
# Deploy Nginx reverse proxy
kubectl apply -f ../../k8s/nginx-reverse-proxy.yaml
# Then update ingress-openedx.yaml to point to openedx-nginx service
```

Add probes and media mounts:
```
bash ../../scripts/apply-probes.sh
bash ../../scripts/apply-media-mount.sh
```
See docs/probes.md for worker probe examples.
## 9) Validate
```
kubectl get pods -n openedx
kubectl get ingress -n openedx
kubectl describe hpa -n openedx
```

## 10) CloudFront + WAF
Terraform module creates CloudFront and WAF. Set `lb_dns_name` to the NLB DNS from the Nginx Ingress service:
```
kubectl get svc -n ingress-nginx ingress-nginx-controller
```
Update DNS to point to CloudFront distribution. Evidence instructions in docs/evidence-checklist.md.
