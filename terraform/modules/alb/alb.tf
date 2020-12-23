data "aws_caller_identity" "this" {}

resource "aws_lb" "this" {
  name                       = var.app
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this.id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = true
  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    prefix  = var.app
    enabled = true
  }
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.app}-alb-log"
  acl    = "private"
  tags = {
    Name      = var.app
    CreatedBy = var.created_by
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.elb_account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.this.id}/${var.app}/AWSLogs/${data.aws_caller_identity.this.account_id}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.this.id}/${var.app}/AWSLogs/${data.aws_caller_identity.this.account_id}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.this.id}"
    }
  ]
}
POLICY
}
