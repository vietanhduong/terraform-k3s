terraform {
  backend "gcs" {
    bucket = "tf-k3s"
    prefix = "node"
  }
}