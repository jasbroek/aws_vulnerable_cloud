resource "aws_iam_instance_profile" "profile_for_ec2_ubuntu" {
  name = "EC2_Profile_allow_s3"
  role = aws_iam_role.role_allow_s3.name
}

resource "aws_iam_role" "role_allow_s3" {
  name = "ec2RoleAllowS3"
  path = "/"
  description = "Allow full S3 access"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# Define policy for bucket access
resource "aws_iam_policy" "S3LimitedRead" {
  name        = "S3LimitedReadAccess"
  description = "This policy gives limited read access to s3 buckets."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:Get*",
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.fc_web_bucket.arn}",
        "${aws_s3_bucket.fc_bucket.arn}"
      ]
    },
    {
      "Action": "s3:ListAllMyBuckets",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}



# Attach s3 access policy to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_s3_full_access" {
  role       = aws_iam_role.role_allow_s3.name
  policy_arn = aws_iam_policy.S3LimitedRead.arn
} 



