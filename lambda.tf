resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"

    assume_role_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service":"lambda.amazonaws.com"
            },
            "Effect":"Allow",
            "Sid":""
        }
    ]
}
EOF
}

resource "aws_lambda_layer_version" "lambda_layer_appmysql" {
    filename            = "./lambda/python.zip"
    layer_name          = "appmysql-v1"
    compatible_runtimes = ["python3.9"] 
}

resource "aws_lambda_function" "lambda_get_mysqlsql" {
    filename        = "./lambda/app.py.zip"
    function_name   = "Lambda_app_Playlist1"
    role            = aws_iam_role.iam_for_lambda.arn
    handler         = "app.lambda_handler"

    runtime = "python3.9"

    layers = [aws_lambda_layer_version.lambda_layer_appmysql.arn]

    environment {
      variables = {
        db_instance_address     = aws_db_instance.rds_mysql_01.address
        db_username             = aws_db_instance.rds_mysql_01.username
        db_password             = aws_db_instance.rds_mysql_01.password
        db_port                 = aws_db_instance.rds_mysql_01.port
        db_name                 = aws_db_instance.rds_mysql_01.db_name
      }
    }
  
}