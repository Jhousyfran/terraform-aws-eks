# Terraform AWS EKS Setup
![Capa do projeto](assets/cover.png)

Infraestrutura em Terraform para subir um cluster EKS completo com rede, node group gerenciado e integração com AWS Load Balancer Controller.

## Menu
- [Visao geral](#visao-geral)
- [Arquitetura](#arquitetura)
- [Modulos](#modulos)
- [Requisitos](#requisitos)
- [Variaveis principais](#variaveis-principais)
- [Como usar](#como-usar)
- [Destruir](#destruir)
- [terraform-doc](#terraform-doc)


## Visao geral
Este projeto entrega uma base opinionada para Kubernetes na AWS. Ele cria a VPC com subnets publicas e privadas, um cluster EKS, um managed node group e a configuracao de IAM/OIDC para o AWS Load Balancer Controller.

## Arquitetura
- VPC dedicada com subnets publicas e privadas
- Cluster EKS com OIDC habilitado
- Managed Node Group com Launch Template
- AWS Load Balancer Controller preparado via IAM

## Modulos
- `modules/network`: VPC, subnets e dependencias de rede
- `modules/cluster`: cluster EKS e outputs de OIDC
- `modules/managed-node-group`: node group gerenciado com launch template
- `modules/aws-loadbalacer-controller`: IAM e permissoes para o controller

## Requisitos
- Terraform 1.x
- AWS CLI configurado com credenciais validas
- Permissoes para criar recursos EKS/VPC/IAM

## Variaveis principais
Defina as variaveis em `terraform.tfvars` ou via CLI.

```hcl
prefix      = "terraform"
project     = "eks-setup"
environment = "dev"
aws_region  = "us-east-1"
cluster_name = "eks-cluster"
# Obrigatorio
cidr_block  = "10.0.0.0/16"
```

## Como usar
```bash
terraform init
terraform plan
terraform apply
```

## Destruir
```bash
terraform destroy
```

# Terraform-doc
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.27.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 3.0.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | ./modules/cluster | n/a |
| <a name="module_eks_loadbalancer_controller"></a> [eks\_loadbalancer\_controller](#module\_eks\_loadbalancer\_controller) | ./modules/aws-loadbalacer-controller | n/a |
| <a name="module_managed_node_group"></a> [managed\_node\_group](#module\_managed\_node\_group) | ./modules/managed-node-group | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Região AWS onde os recursos serão criados | `string` | `"us-east-1"` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | Bloco CIDR para a VPC | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nome do cluster EKS | `string` | `"eks-cluster"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Ambiente onde os recursos serão criados | `string` | `"dev"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix para nomear os recursos | `string` | `"terraform"` | no |
| <a name="input_project"></a> [project](#input\_project) | Nome do projeto | `string` | `"eks-setup"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
