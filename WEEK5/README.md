# WEEK 5

## Creating, configuring, and templating deployments

### This is week's content is within the workloads & scheduling section of the exam curriculum
- [Exam Curriculum](https://github.com/cncf/curriculum/blob/master/CKA_Curriculum_v1.24.pdf)

We'll focus on creating deployments both from scratch and by using Helm. We'll also discover configuration settings with configmaps, secrets, and resource requests

## RESOURCES 

- [VIDEO: What is Helm and Helm Charts](https://youtu.be/-ykwb1d0DXU)
- [VIDEO: Introduction to Helm](https://youtu.be/5_J7RWLLVeQ)
- [VIDEO: Hands on w/Helm](https://youtu.be/6d6L4-ADF-M)
- [Helm Quickstart](https://helm.sh/docs/intro/quickstart/)
- [The Big Three Concepts](https://helm.sh/docs/intro/using_helm/)
- [Helm Tutorial](https://www.freecodecamp.org/news/what-is-a-helm-chart-tutorial-for-kubernetes-beginners/)
- [Helm vs. Kustomize](https://harness.io/blog/helm-vs-kustomize)

## CHALLENGES

> Put all YAML files in WEEK5 Directory

1. Install the nginx ingress controller nginx-stable via https://helm.nginx.com/stable
2. Install Hashicorp Vault via helm chart `hashicorp/vault` at https://helm.releases.hashicorp.com
3. Override the values file for vault using the default here: https://github.com/hashicorp/vault-helm/blob/main/values.yaml
4. Create a helm chart from scratch and deploy it to Kubernetes