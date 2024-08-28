data "archive_file" "main" {
  type        = "zip"
  source_dir  = var.archive_source_dir
  output_path = var.archive_output_path
}

resource "aws_lambda_layer_version" "main" {
  layer_name          = var.layer_name
  compatible_runtimes = var.compatible_runtimes
  filename            = var.archive_output_path
}
