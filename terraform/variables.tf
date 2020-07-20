variable "profile" {
  default = "default"
}

variable "bucket_name" {
  default = "fc-bucket"
}


variable "region" {
  default = "eu-west-3"
}

# Used for unique naming of resources 
variable "unique_id" {
  default = "284ab91da09DalE"
}

# IP addresses allowed to connect to the instances
variable "connection_ips" {
  
}

# Define SSH key variables
variable "ssh_private_key" {
  default = "../assets/keys/ssh_key"
}

variable "ssh_public_key" {
  default = "../assets/keys/ssh_key.pub"
}
