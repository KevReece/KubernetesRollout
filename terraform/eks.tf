provider "aws" {
  region = "eu-central-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks_cluster_sg"
  description = "Allow inbound traffic to EKS cluster"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTPS traffic from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks_cluster_sg"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ])
  role      = aws_iam_role.eks_cluster_role.name
  policy_arn = each.value
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.0"
  cluster_name    = "eks-cluster"
  cluster_version = "1.30"
  vpc_id          = data.aws_vpc.default.id
  subnet_ids      = data.aws_subnets.default.ids
  iam_role_arn    = aws_iam_role.eks_cluster_role.arn

  cluster_security_group_id = aws_security_group.eks_cluster_sg.id
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    eks_nodes = {
      desired_size  = 1
      max_size      = 1
      min_size      = 1
      instance_type = "t3.micro"
      iam_role_arn  = aws_iam_role.eks_cluster_role.arn
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
