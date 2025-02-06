variable "region" {
  description = "Default region for provider"
  type        = string
}
variable "environment" {
  description = "Environment for the application"
  type        = string
}
variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "subnet_id" {
  description = "The ID of the subnet for the jumpbox"
  type        = string
}
variable "jumpbox_sg_id" {
  description = "The ID of the security group for the jumpbox"
  type        = string

}
