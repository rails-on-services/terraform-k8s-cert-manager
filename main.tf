data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

# data "http" "cert-manager-crd" {
#   url = "https://raw.githubusercontent.com/jetstack/cert-manager/release-${var.cm_version}/deploy/manifests/00-crds.yaml"
# }

data "kubectl_filename_list" "manifests" {
    pattern = "${path.module}/files/*.yaml"
}

resource "kubectl_manifest" "cert-manager-crd" {
    depends_on = [var.cm_depends_on]
    for_each   = toset(data.kubectl_filename_list.manifests.matches)
    yaml_body  = file(each.key)
}
resource "helm_release" "cert-manager" {
  depends_on = [
    kubectl_manifest.cert-manager-crd
  ]
  name       = "cert-manager"
  repository = data.helm_repository.jetstack.metadata.0.name
  chart      = "cert-manager"
  version    = "v${var.cm_version}.0"
  namespace  = var.namespace
  wait       = true
}
