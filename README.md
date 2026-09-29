
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
