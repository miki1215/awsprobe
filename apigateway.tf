
// Create
resource "aws_apigatewayv2_api" "example" {
  name          = "example-http-api"
  protocol_type = "HTTP"

}
// Integrate to lambda
resource "aws_apigatewayv2_integration" "exampleintegration" {
  api_id           = aws_apigatewayv2_api.example.id
  integration_type = "AWS_PROXY"
  integration_uri           = aws_lambda_function.lambda_terraform_1.invoke_arn
  connection_type           = "INTERNET"
  description               = "Lambda example"
  integration_method        = "POST"
  payload_format_version    = "2.0"
}
//Give permission to lambda
resource "aws_lambda_permission" "lambda_permissionfromapi" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "lambda_terraform_1"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.example.execution_arn}/$default"
}

//Stage the API  Gateway
resource "aws_apigatewayv2_stage" "lambdastage" {
  api_id = aws_apigatewayv2_api.example.id

  name        = "api_lambda_stage"
  auto_deploy = true
}
// Route the APi
resource "aws_apigatewayv2_route" "apiroute" {
  api_id = aws_apigatewayv2_api.example.id

  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.exampleintegration.id}"
}


output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambdastage.invoke_url
}
output "base" {
  description = "B stage."

  value = aws_lambda_function.lambda_terraform_1.invoke_arn
}