resource "aws_lambda_function" "ingest" {
  function_name = "event-ingest-lambda"

  filename         = data.archive_file.ingest_zip.output_path
  source_code_hash = data.archive_file.ingest_zip.output_base64sha256

  role    = aws_iam_role.lambda_exec.arn
  handler = "bootstrap"     # Para runtime provided.al2023, o handler é sempre bootstrap
  runtime = "provided.al2023" # Runtime mais moderna e rápida para Go

  # Timeout curto pois ela só deve receber e passar pra frente (futuro SQS)
  timeout = 10
}
