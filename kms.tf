resource "aws_kms_key" "master-kms-key" {
  description             = "master KMS key"
  deletion_window_in_days = 7
}