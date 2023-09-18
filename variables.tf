variable "environment" {
    description = "setup o environment"  
}

variable "project_name" {
    description = "Nome do Projeto"  
}

variable "bucket_names" {
    type = list(string)
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
    sensitive = true
}