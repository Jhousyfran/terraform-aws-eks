resource "aws_eks_node_group" "eks_mng_nodegroup" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.prefix}-mng-nodegroup"
  node_role_arn   = aws_iam_role.eks_managed_nodegroup_role.arn
  subnet_ids = [
    var.private_subnet_1a_id,
    var.private_subnet_1b_id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  capacity_type  = "SPOT"
  instance_types = ["t3.medium"]

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-mng-node-group"
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks_managed_nodegroup_role_attachment_worker,
    aws_iam_role_policy_attachment.eks_managed_nodegroup_role_attachment_ecr,
    aws_iam_role_policy_attachment.eks_managed_nodegroup_role_attachment_cni
  ]

}
