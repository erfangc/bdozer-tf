resource "aws_secretsmanager_secret" "elasticsearch_credential" {
  name        = "elasticsearch_credential"
  description = "elasticsearch_credential"
}
resource "aws_secretsmanager_secret" "jdbc_password" {
  name        = "jdbc_password"
  description = "jdbc_password"
}
resource "aws_secretsmanager_secret" "polygon_api_key" {
  name        = "polygon_api_key"
  description = "polygon_api_key"
}
resource "aws_secretsmanager_secret" "quandl_api_key" {
  name        = "quandl_api_key"
  description = "quandl_api_key"
}
resource "aws_secretsmanager_secret" "client_id" {
  name        = "client_id"
  description = "client_id"
}
resource "aws_secretsmanager_secret" "client_secret" {
  name        = "client_secret"
  description = "client_secret"
}