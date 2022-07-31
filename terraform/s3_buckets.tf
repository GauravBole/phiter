resource "aws_s3_bucket" "phiter" {
  bucket = "phiter"
  tags = {
    Name        = "Environmanet"
    Environment = var.environmanet

  }
}

resource "aws_s3_bucket_object" "packages" {
  bucket = aws_s3_bucket.phiter.id
  key    = "packages/"

}

resource "aws_s3_bucket_object" "scripts" {
  bucket = aws_s3_bucket.phiter.id
  key    = "scripts/"
}

resource "aws_s3_bucket_object" "temp_dir" {
  bucket = aws_s3_bucket.phiter.id
  key    = "temp_dir/"
}

