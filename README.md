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

*** I used Prometheus instead of Cloudwatch as i was not haivng the AWS account as my previous accounts are expired**
**I have tested it on KIND and made it to be used on EKS**

CI/CD Workflow Explanation
CI (Continuous Integration)
<img width="1241" height="353" alt="Screenshot 2025-12-14 013835" src="https://github.com/user-attachments/assets/4accc10f-627d-4cf5-a1ee-cdbaba16f370" />

**
Triggered on every push to main:**

1.	Checkout code

2.	Build Docker image

3.	Tag image with Git commit SHA

4.	Push image to Docker Hub

**CD (Continuous Deployment)**

<img width="1345" height="615" alt="Screenshot 2025-12-14 014502" src="https://github.com/user-attachments/assets/afd8c365-f08b-457b-a37d-4c94ccbe0f12" />


1.	Configure AWS credentials via OIDC (no static keys)

2.	Update kubeconfig for EKS

3.	Update Kubernetes Deployment image

4.	Kubernetes performs Rolling Update


**Provision EKS via Terraform**
1.	1.terraform init
2.	2.terraform apply


**Update kubeconfig:**

aws eks update-kubeconfig --name pythonapp-eks --region ap-south-1

**Deploy Application to EKS**
kubectl apply -f k8s/

**Verify:**
kubectl get pods
kubectl get svc

****Monitoring & Alert Design**
Metrics Collected (via Prometheus)**


1.	CPU usage

2.	Memory usage

3.	Pod health status

4.	Container restarts (error indicator)

5.	Grafana Dashboard

**Dashboard panels:**
<img width="1154" height="658" alt="Screenshot 2025-12-14 014233" src="https://github.com/user-attachments/assets/56285bf6-f962-440f-9cbb-57cfe44205d6" />


1.	Pod CPU usage

2.	Pod memory usage

3.	Pod availability

4.	Restart count

** Alerts (Grafana Alert Rules)**

1.	High CPU or Memory Usage
<img width="1257" height="541" alt="Screenshot 2025-12-14 013208" src="https://github.com/user-attachments/assets/31b07170-d383-41da-b0c7-18f73ebec146" />

2.	Trigger when CPU or memory usage exceeds threshold for 5 minutes

**Health Check Failure**
<img width="1140" height="537" alt="Screenshot 2025-12-14 013533" src="https://github.com/user-attachments/assets/c0a3e687-fe37-42db-867f-6cec66f63cd1" />

1.	Trigger when pod is not Ready

2.	Trigger on repeated container restarts

**Security Considerations**
1.	IAM Least Privilege

2.	EKS node groups have only required permissions

3.	GitHub Actions uses OIDC IAM Role (no long-lived keys)

** Secrets Management**

1.	No secrets stored in GitHub repo

2.	Kubernetes Secrets can reference:

3.	AWS Secrets Manager

4.	AWS SSM Parameter Store

5.	No Credentials in Repository

6.	Docker Hub credentials stored in GitHub Secrets

7.	AWS authentication via role assumption

 **HTTPS Enforcement**

In production, HTTPS would be enforced using:

1.	AWS ALB Ingress Controller

2.	TLS certificates via ACM

