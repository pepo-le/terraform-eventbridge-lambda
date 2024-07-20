variable "event_name" {
  description = "EventBridgeのイベント名"
  type        = string
}

variable "event_description" {
  description = "EventBridgeのイベントの説明"
  type        = string
  default     = ""
}

variable "schedule_expression" {
  description = "EventBridgeのスケジュール式"
  type        = string
}

variable "lambda_arn" {
  description = "Lambda関数のARN"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda関数の名前"
  type        = string
}

variable "retry_attempts" {
  description = "リトライ回数"
  type        = number
  default     = 0
}

variable "event_age" {
  description = "イベントの最大保持時間"
  type        = number
  default     = 60
}

variable "policy_statement_id" {
  description = "ポリシーステートメントID"
  type        = string
}
