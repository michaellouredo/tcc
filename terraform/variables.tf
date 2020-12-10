variable "region" { 
  default = { dev = "us-east-1"
              stg = "us-east-1" 
              prd = "us-east-1" } 
}

variable "s3_name" {
  default = {
    dev = "dev-unigranrio"
    stg = "stg-unigranrio"
    prd = "unigranrio"
  }
}

variable "tags" {
  default = {
    terrafrom	= "true"
    project	= "TCC"
  }
}

variable "s3_index_filename" {
  default = "index.html"
}

variable "s3_error_filename" {
  default = "error.html"
}
