resource "google_storage_bucket" "static-site" {
  name          =  var.bucket_name
  location      = var.region 
}