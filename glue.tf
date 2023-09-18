resource "aws_iam_role" "glue_job" {
    name                = "${var.project_name}-${var.environment}-glue-job-role"
    path                = "/"
    description         = "Fornece permissões de gravação para CloudWatch Logs e S3 Full Access"
    assume_role_policy  = file("permissao/role_glueJobs.json")
}

resource "aws_iam_policy" "glue_job_policy" {
    name                = "${var.project_name}-${var.environment}-glue-job-policy"
    path                = "/"
    description         = "Fornece permissões de gravação para CloudWatch Logs e S3 Full Access"
    policy  = file("permissao/policy_glueJobs.json")
}

resource "aws_glue_job" "glue_job" {
    name                = "jobGlueDelta"
    role_arn            = aws_iam_role.glue_job.arn
    glue_version        = "3.0"
    worker_type         = "Standard"
    number_of_workers   = 5
    timeout             = 5

    command {
      script_location   = "${var.project_name}-scripts-glue-${var.environment}/job/job-Glue.py"
      python_version    = "3"
    }

    default_arguments = {
      "--additional-python-modules"         = "delta-spark==1.0.0"
      "--extra-jars"                        = "${var.project_name}-scripts-glue-${var.environment}/jars/delta-core_2.12-1.0.0.jar"
      "--conf spark.delta.logStore.class"   = "org.apache.spark.sql.delta.storage.S3SingleDriverLogStore"
      "--conf spark.sql.extensions"         = "io.delta.sql.DeltaSparkSessionExtension"
    }
}