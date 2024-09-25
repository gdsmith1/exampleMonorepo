variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
  default = "gibson-website-bucket"
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "sandbox"
  }
}