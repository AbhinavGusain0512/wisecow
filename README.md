# 🐄 Wisecow Application — DevOps Project

A containerized web application that serves random
fortune quotes via an ASCII cow, deployed on Kubernetes
with TLS and automated CI/CD.

---

## 🏗️ Architecture

Internet → HTTPS → Ingress (nginx) → Service → Pods (x2)
↑
TLS via cert-manager
↑
wisecow-tls-secret

---

## 🧰 Tech Stack

| Layer | Technology |
|-------|-----------|
| Application | Bash + cowsay + fortune + netcat |
| Container | Docker |
| Orchestration | Kubernetes (Kind for local) |
| TLS | cert-manager (self-signed) |
| CI/CD | GitHub Actions |
| Registry | Docker Hub |

---

## 🚀 Quick Start

### Prerequisites
- Docker
- kubectl
- Kind

### Run Locally with Docker
```bash
docker pull abhinavgusain0512/wisecow:latest
docker run -p 8080:4499 abhinavgusain0512/wisecow:latest
# Visit http://localhost:8080
```

### Deploy to Kubernetes
```bash
# Create cluster
kind create cluster --name wisecow --config kind-config.yaml

# Install ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.yaml

# Deploy application
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/tls/issuer.yaml
kubectl apply -f k8s/tls/certificate.yaml

# Access the app
kubectl port-forward -n ingress-nginx \
  service/ingress-nginx-controller 8443:443
# Visit https://wisecow.local:8443
```

---

## 🔄 CI/CD Pipeline

Every push to `main` automatically:
1. Builds Docker image
2. Tags with `latest` and commit SHA
3. Pushes to Docker Hub

### Secrets Required
| Secret | Description |
|--------|-------------|
| DOCKER_USERNAME | Docker Hub username |
| DOCKER_PASSWORD | Docker Hub access token |

---

## 📁 Project Structure
├── .github/workflows/
│   ├── deploy.yml         # CI/CD pipeline
│   └── health-check.yml   # Health monitoring
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── tls/
│       ├── issuer.yaml
│       └── certificate.yaml
├── Dockerfile
├── kind-config.yaml
└── wisecow.sh

---

## 🔐 TLS

Uses cert-manager with self-signed certificates for
local development. For production, replace the Issuer
with Let's Encrypt ACME configuration.

---

## 🩺 Health Monitoring

Automated health checks run every 30 minutes via
GitHub Actions, verifying pod status and TLS
certificate validity.
