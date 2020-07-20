resource "aws_iam_user" "bob" {
  name          = "bob"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "bob" {
  user = aws_iam_user.bob.name
}

# Create 'bob-group' IAM group
resource "aws_iam_group" "bob" {
  name = "bob-group"
  path = "/"
}

#IAM User Policies
resource "aws_iam_policy" "bob-policy" {
  name = "bob-policy"
  description = "bob-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": [
            "lambda:listFunctions", "lambda:getFunction", "s3:ListAllMyBuckets"
          ],
          "Effect": "Allow",
          "Resource": "*"
        },
        {
          "Action": [
            "s3:Get*", "s3:Put*"
          ],
          "Effect": "Allow",
          "Resource": ["${aws_s3_bucket.lambda.arn}", "${aws_s3_bucket.lambda.arn}/*"]
        }
    ]
}
EOF
}

# Attach policy to the bob-group
resource "aws_iam_group_policy_attachment" "bob" {
  group      = aws_iam_group.bob.name
  policy_arn = aws_iam_policy.bob-policy.arn
}

# Add bob to the group
resource "aws_iam_user_group_membership" "bob" {
  user = aws_iam_user.bob.name

  groups = [
    "${aws_iam_group.bob.name}",
  ]
}