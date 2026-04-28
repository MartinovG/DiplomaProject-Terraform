# DiplomaProject — Terraform

Infrastructure for a Kubernetes-based deployment platform on AWS, built as a diploma project. Three repos make up the full system:

- **This repo** — Terraform (VPC, EKS, controllers, secrets, ECR, ACM)
- [DiplomaProject-ArgoCD](https://github.com/MartinovG/DiplomaProject-ArgoCD) — GitOps configs, Helm charts, monitoring manifests
- [DiplomaProject-App](https://github.com/MartinovG/DiplomaProject-App) — Next.js frontend + Express/Prisma backend

---

## What it provisions

**Networking**
- VPC `10.0.0.0/18` across 3 AZs in `eu-central-1`
- Public, private, and database subnets — one NAT gateway per AZ
- Subnet tags for Karpenter discovery and ALB routing

**EKS (`1.34`)**
- Managed node group: 2× `t3.xlarge` (dedicated to cluster controllers)
- Karpenter handles all workload scaling (spot + on-demand, spot-to-spot consolidation enabled)
- Add-ons: VPC CNI, EBS CSI, CoreDNS, kube-proxy — all with IRSA roles

**Controllers (deployed via Helm)**
- **ArgoCD** — ingress via ALB, HTTPS via ACM, DNS via External DNS
- **AWS Load Balancer Controller** — provisions ALBs for ingresses
- **External DNS** — syncs Route53 records from ingress annotations
- **ACK RDS Controller** — creates PostgreSQL RDS instances from Kubernetes CRDs

**Secrets & Identity**
- External Secrets Operator pulls from AWS Secrets Manager (`gm-diploma-project/*`)
- All controllers use IRSA (per-service-account IAM roles via OIDC)
- Secrets Manager entries: Grafana admin creds, Alertmanager config, preview DB credentials

**State backend (global)**
- S3 bucket with versioning, fully blocked public access
- DynamoDB table for state locking

**ECR**
- Two repositories: `api` and `frontend`

---

## Repository layout

```
global/               # S3 + DynamoDB for Terraform state
eu-central-1/
  vpc/                # VPC, subnets, NAT gateways
  acm/                # ACM certificate for *.elsys.itgix.eu
  ecr/                # ECR repositories + OIDC federation for GitHub Actions
  eks/
    main.tf           # EKS cluster + RDS security group
    karpenter.tf      # Karpenter + metrics-server
    controllers.tf    # ALB controller, External DNS, ACK RDS
    argo.tf           # ArgoCD Helm release
    irsa.tf           # IAM roles for service accounts
    secrets.tf        # Secrets Manager resources
    storage-class.tf  # GP3 default storage class
Modules/
  alb_controller/
  dns_controller/
  ack_rds_controller/
```

---

## Deployment flow

```
PR opened on DiplomaProject-App
        │
        ▼
ArgoCD ApplicationSet (pullRequest generator)
        │
        ├── creates namespace pr-{N}
        ├── deploys frontend + backend from ECR (tag: backend-pr-{N})
        ├── provisions isolated RDS DB via ACK (gm-diplomaproject-db-pr-{N})
        └── exposes at https://pr-{N}.elsys.itgix.eu

PR merged to main
        │
        ▼
ArgoCD Application (gm-diploma-project-prd)
        └── syncs eu-central-1/prod/helm → gm-diploma-project-prod namespace
```

Monitoring (Prometheus + Grafana + Loki + Tempo + Alloy) is deployed as a separate ArgoCD Application from `eu-central-1/prod/monitoring`.

---

## Prerequisites

- AWS credentials configured (`eu-central-1`)
- Terraform >= 1.x
- `us-east-1` access for Karpenter ECR public auth token (provider alias `aws.virginia`)
- State bucket must exist before applying `eu-central-1/*` modules

## Apply order

```bash
# 1. Bootstrap state backend
cd global && terraform init && terraform apply

# 2. Network
cd eu-central-1/vpc && terraform init && terraform apply

# 3. Certificates
cd eu-central-1/acm && terraform init && terraform apply

# 4. ECR
cd eu-central-1/ecr && terraform init && terraform apply

# 5. EKS + everything else
cd eu-central-1/eks && terraform init && terraform apply
```

> The EKS module includes a note in `main.tf` — the `access_entries` block for Karpenter nodes should be commented out on first apply, then uncommented once Karpenter's IAM role exists.
