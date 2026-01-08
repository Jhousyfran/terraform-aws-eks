# terraform-aws-eks

Índice
- Descrição
- Pré-requisitos
- Estrutura do projeto
- Uso rápido
- Exemplos de configuração
- Variáveis importantes
- Outputs importantes
- Estado remoto (opcional)
- Dicas e troubleshooting
- Licença

Descrição
Provisiona um cluster EKS (control plane + node groups) e recursos associados (IAM, VPC, Security Groups). Foco em boas práticas: modularidade, outputs úteis e configuração para kubectl.

Pré-requisitos
- Terraform >= 1.5.0
- AWS CLI configurada (~/.aws/credentials ou variáveis de ambiente)
- Permissões AWS suficientes (IAM, EKS, EC2, VPC, CloudFormation)
- kubectl (para acessar o cluster após provisionamento)

Estrutura
- main.tf
- variables.tf
- outputs.tf
- modules/
    - network/
    - eks/
    - node_groups/

Uso rápido
1. Ajustar variáveis em terraform.tfvars ou via CLI.
2. Inicializar:
     ```
     terraform init
     ```
3. Planejar:
     ```
     terraform plan -out=plan.tfplan
     ```
4. Aplicar:
     ```
     terraform apply "plan.tfplan"
     ```
5. Configurar kubectl:
     ```
     aws eks --region <region> update-kubeconfig --name <cluster_name>
     ```
6. Validar:
     ```
     kubectl get nodes
     ```

Exemplo de configuração (exemplo mínimo)
```
terraform {
    required_version = ">= 1.5.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

module "vpc" {
    source = "./modules/vpc"
    name   = "poc-vpc"
    cidr   = "10.0.0.0/16"
}

module "eks" {
    source            = "./modules/eks"
    cluster_name      = "poc-eks"
    vpc_id            = module.vpc.vpc_id
    public_subnet_ids = module.vpc.public_subnet_ids
    private_subnet_ids= module.vpc.private_subnet_ids
    node_groups = {
        default = {
            desired_capacity = 2
            instance_types   = ["t3.medium"]
        }
    }
}
```

Variáveis importantes (exemplos)
- region: região AWS
- cluster_name: nome do EKS
- vpc_id, subnet_ids: rede onde o EKS será criado
- node_groups: mapa de grupos de nós (desired, min, max, instance_types)
- kubernetes_version: versão do EKS

Outputs úteis
- cluster_name: nome do cluster
- cluster_endpoint: endpoint API server
- cluster_ca_certificate: CA do cluster
- kubeconfig: conteúdo do kubeconfig (opcional / sensível)
- node_group_names / node_ips

Estado remoto (recomendado)
Usar backend S3 + Locking via DynamoDB para times:
```
terraform {
    backend "s3" {
        bucket = "meu-terraform-state"
        key    = "eks/project/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-locks"
        encrypt = true
    }
}
```

Dicas e troubleshooting
- Verifique quotas de EC2 e IAM antes de criar recursos.
- Habilite logging de API e audit se necessário.
- Se o `aws eks update-kubeconfig` falhar, confira STS/assume-role e credenciais.
- Para debug do Terraform use `TF_LOG=DEBUG`.

Segurança
- Evite commitar terraform.tfvars com segredos.
- Gerencie credenciais via roles e profiles.
- Habilite policies mínimas para o principal que executa o Terraform.

Contribuição
Abrir issues e pull requests com descrições claras e exemplos.

Licença
MIT — consulte o arquivo LICENSE para detalhes.