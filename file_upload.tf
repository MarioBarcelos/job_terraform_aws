resource "aws_s3_object" "jars" {
    bucket          = "${var.project_name}-scripts-glue-${var.environment}-${terraform.workspace}"
    key             = "./jars/delta-core_2.12-1.0.0.jar"
    source          = "./jars/delta-core_2.12-1.0.0.jar"
    etag            = filemd5("jars/delta-core_2.12-1.0.0.jar")
    depends_on      = [aws_s3_bucket.bucket_orig ]
}

resource "aws_s3_object" "job-Glue" {
    bucket          = "${var.project_name}-scripts-glue-${var.environment}-${terraform.workspace}"
    key             = "job/job-Glue.py"
    source          = "job/job-Glue.py"
    etag            = filemd5("job/job-Glue.py")
    depends_on      = [aws_s3_bucket.bucket_orig ]
}