
# Enterprise GenAI Platform on AWS

A reproducible AWS reference implementation demonstrating secure,
private, and reusable enterprise Generative AI workloads using
Amazon Bedrock, Retrieval-Augmented Generation (RAG), Amazon EKS,
and automated infrastructure delivery.

## Project Objectives

- Design reusable AI platform architecture on AWS.
- Implement secure infrastructure using Infrastructure as Code.
- Support RAG and text-generation workflows.
- Apply cloud security and least-privilege access principles.
- Automate application build, testing, and deployment.
- Incorporate observability, resilience, AI governance, and cost controls.
- Document architecture decisions, implementation challenges, and lessons learned.

## Technology Stack

- **Cloud:** Amazon Web Services (AWS)
- **Application:** Python, FastAPI
- **AI:** Amazon Bedrock, Knowledge Bases, S3 Vectors
- **Compute:** Amazon EKS, Kubernetes, Docker
- **Infrastructure:** Terraform
- **CI/CD:** GitHub Actions, Amazon ECR
- **Security:** IAM, EKS Pod Identity, Cognito, Private Networking
- **Monitoring:** Amazon CloudWatch

## Project Status

Under active development.

This repository is being built incrementally as a reproducible
reference implementation. Individual capabilities will be marked
as implemented and validated as development progresses.

## Development Workflow & Quality Checks

The repository uses [pre-commit](https://pre-commit.com/) to run security and code-quality checks locally before changes are committed. GitHub Actions provides additional CI validation.

### One-time setup

From the repository root, activate the Python virtual environment and install the Git hooks:

```bash
source .venv/bin/activate
pre-commit install
```

### Validate changes before committing

For Terraform changes, run the following from the repository root:

```bash
cd infrastructure/environments/lab
terraform fmt -recursive ../../
terraform validate
terraform plan
cd ../../..
```

Review the plan carefully before any `terraform apply`, especially when enabling billable resources such as NAT Gateway or EKS. Keep local `terraform.tfvars` files and Terraform state out of version control.

Run all configured pre-commit checks:

```bash
pre-commit run --all-files
```

The configured checks cover secret detection (Gitleaks), Python linting and formatting (Ruff), trailing whitespace, end-of-file formatting, YAML/JSON validity, merge-conflict markers, and oversized files. Hooks may be skipped when no applicable files are present.

### Stage, review, commit, and push

```bash
git status --short
git diff --check
git add <paths-to-commit>
git diff --cached --stat
git diff --cached --check
git diff --cached
git commit -m "feat: describe the change"
git push origin main
```

Replace `<paths-to-commit>` with the intended files or directories (for example, `README.md` or `infrastructure/`). The pre-commit hooks run again automatically during `git commit`. If a hook changes a file, review and stage the updated file before retrying.

Finally, confirm that the working tree is clean:

```bash
git status
git log -1 --oneline
```

**Security reminder:** Never commit AWS credentials, API keys, `.env` files, real `terraform.tfvars` files, Terraform state, or other secrets. Automated checks supplement, but do not replace, manual review.


## Reference Architecture

Architecture overview:

https://www.ransarnova.com/reference-architectures

## Security

This repository does not require committed AWS credentials or
application secrets. Deployment-specific configuration must be
provided outside version control.

## Author and Maintainer

Randhir Kumar

## License

Copyright 2026 Randhir Kumar.

Licensed under the Apache License, Version 2.0.
See [LICENSE](LICENSE) for details.
