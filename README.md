# simple_application
Developer
   |
   | Git Push
   v
GitHub Repository
   |
   | GitHub Actions (CI/CD)
   |
   |-- Build & Push Docker Image (Docker Hub)
   |
   |-- kubectl apply (Rolling Update)
   v
AWS EKS Cluster
   |
   |-- Kubernetes Deployment (pythonapp)
   |-- Kubernetes Service (ClusterIP)
   |
   |-- Prometheus (metrics)
   |-- Grafana (dashboards + alerts)

* I used Prometheus instead of Cloudwatch

CI/CD Workflow Explanation
CI (Continuous Integration)

Triggered on every push to main:

1.Checkout code

2.Build Docker image

3.Tag image with Git commit SHA

4.Push image to Docker Hub

CD (Continuous Deployment)

1.Configure AWS credentials via OIDC (no static keys)

2.Update kubeconfig for EKS

3.Update Kubernetes Deployment image

4.Kubernetes performs Rolling Update

