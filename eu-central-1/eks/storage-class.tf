resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"
    annotations = {
        "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

    storage_provisioner = "ebs.csi.aws.com"
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
    allow_volume_expansion = true
    parameters = {
        fsType = "ext4"
        type = "gp3"

    }
  }
