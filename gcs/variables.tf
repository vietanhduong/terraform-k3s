variable "project" {
  type      = string
  sensitive = true
}
variable "region" {
  type    = string
  default = "asia-southeast1"
}
variable "zone" {
  type    = string
  default = "asia-southeast1-b"
}
variable "bucket_name" {
  type = string
}
