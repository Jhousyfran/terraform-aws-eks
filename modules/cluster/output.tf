output "eks_vpc_config" {
  description = "Configuração VPC do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.vpc_config

}
