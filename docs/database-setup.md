# Database Setup (In-Cluster StatefulSets)

This assessment requires in-cluster databases when managed services are not fully API compatible. MongoDB and Elasticsearch are deployed inside the cluster using StatefulSets with persistent volumes.

## 1) Create Namespace
```
kubectl apply -f ../k8s/db/namespace.yaml
```

## 2) Install MongoDB (Bitnami)
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install mongodb bitnami/mongodb \
  -n openedx-db \
  -f ../helm-values/mongodb-values.yaml
```
Note: The values file expects a `gp3` StorageClass. If your cluster uses a different default, update the values or apply `k8s/storageclass-ebs-gp3.yaml`.

## 3) Install Elasticsearch (Bitnami)
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install elasticsearch bitnami/elasticsearch \
  -n openedx-db \
  -f ../helm-values/elasticsearch-values.yaml
```

## 4) Validate
```
kubectl get pods -n openedx-db
kubectl get sts -n openedx-db
kubectl get pvc -n openedx-db
```

## 5) Connection Endpoints
- MongoDB service: `mongodb.openedx-db.svc.cluster.local`
- Elasticsearch service: `elasticsearch.openedx-db.svc.cluster.local:9200`

Tutor connection hint:
- MongoDB: use the chart-provided credentials and replica set name in `tutor/config.yml`.
- Retrieve MongoDB credentials:
```
kubectl get secret -n openedx-db mongodb -o jsonpath='{.data.mongodb-root-password}' | base64 -d
kubectl get secret -n openedx-db mongodb -o jsonpath='{.data.mongodb-passwords}' | base64 -d
```
