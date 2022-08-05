resource "aws_s3_bucket" "phiter" {
  bucket = var.code_bucket
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

resource "aws_s3_bucket_object" "source_path" {
  bucket = aws_s3_bucket.phiter.id
  key    = "source/"
}


resource "aws_s3_bucket_object" "destination_path" {
  bucket = aws_s3_bucket.phiter.id
  key    = "destination/"
}



# resource "aws_s3_bucket_object" "name" {
#   provisioner "copyfiles" {
#     command = "aws s3 cp "
#   }
  
# }

