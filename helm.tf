provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    host                   = aws_eks_cluster.demo.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority.0.data)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.demo.name]
      command     = "aws"
    }
  }


}

resource "helm_release" "wordpress" {
  name       = "wordpress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  namespace  = "default"
  depends_on = [aws_eks_node_group.demo]


}