

data "archive_file" "lambda_zip" {
  type = "zip"
  output_path = "./lambda.zip"
  source_dir = "./lambdalayer"

}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "lambda.zip"
  layer_name = "lambda_layer_name"

  compatible_runtimes = ["nodejs14.x"]
}





resource "aws_lambda_function" "lambda_terraform_1" {
    role       = aws_iam_role.lambdarole.arn
    function_name = "lambda_terraform_1"
  handler = "index.handler"
  runtime = "nodejs14.x"
  filename = "./function/function.zip"
}

resource "aws_iam_role" "lambdarole" {
    name = "lambdarole"
    assume_role_policy = <<EOF
{ 
        "Version": "2012-10-17",
        "Statement": 
            {
            "Effect": "Allow",
            "Principal": {"Service": "lambda.amazonaws.com"},
            "Action": "sts:AssumeRole"
            }
            
}
EOF
}
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambdarole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

resource "aws_iam_role_policy_attachment" "lambda_policy1" {
  role       = aws_iam_role.lambdarole.name
  policy_arn = aws_iam_policy.transcribepolicy.arn
}
// Policy to give access to ALL Services to the transcribe service,
// es a trancsrbe minden Servicehez
resource "aws_iam_policy" "transcribepolicy" {
    name = "transcribepolicy"
    policy = jsonencode(
{
     "Version": "2012-10-17",
     "Statement":[
        {
        "Action": "transcribe:*",
        "Effect": "Allow",
        "Resource": "*"
       } ]
}
    )
}



