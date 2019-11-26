data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

# k8sraw_yaml doesn't support multiple yaml documents in one file, so can't use remote http resource directly
# data "http" "cert-manager-crd" {
#   url = "https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml"
# }

# resource "k8sraw_yaml" "cert-manager-crd" {
#   yaml_body = data.http.cert-manager-crd.body
# }

# List of CRDs required for cert-manager
resource "k8sraw_yaml" "certificaterequests" {
  depends_on = [var.crd_depends_on]
  yaml_body = file("${path.module}/files/certificaterequests.yaml")
}

resource "k8sraw_yaml" "certificates" {
  depends_on = [var.crd_depends_on]
  yaml_body = file("${path.module}/files/certificates.yaml")
}

resource "k8sraw_yaml" "challenges" {
  depends_on = [var.crd_depends_on]
  yaml_body = file("${path.module}/files/challenges.yaml")
}

resource "k8sraw_yaml" "clusterissuers" {
  depends_on = [var.crd_depends_on]
  yaml_body = file("${path.module}/files/clusterissuers.yaml")
}

resource "k8sraw_yaml" "issuers" {
  depends_on = [var.crd_depends_on]
  yaml_body = file("${path.module}/files/issuers.yaml")
}

resource "k8sraw_yaml" "orders" {
  depends_on = [var.crd_depends_on]
  yaml_body = file("${path.module}/files/orders.yaml")
}

resource "helm_release" "cert-manager" {
  depends_on = [
    k8sraw_yaml.certificaterequests,
    k8sraw_yaml.certificates,
    k8sraw_yaml.challenges,
    k8sraw_yaml.clusterissuers,
    k8sraw_yaml.issuers,
    k8sraw_yaml.orders
  ]
  name       = "cert-manager"
  repository = data.helm_repository.jetstack.metadata.0.name
  chart      = "cert-manager"
  version    = "v0.11.0"
  namespace  = var.namespace
  wait       = true
}