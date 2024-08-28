variable "layer_name" {
  description = "Lambda Layerの名前"
  type        = string
}

variable "compatible_runtimes" {
  description = "互換性のあるランタイム"
  type        = list(string)
}

variable "archive_source_dir" {
  description = "アーカイブするファイルのディレクトリ"
  type        = string
}

variable "archive_output_path" {
  description = "アーカイブしたファイルのパス"
  type        = string
}
