resource "aws_iam_user" "eve" {
  name          = "eve"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "eve" {
  user = aws_iam_user.eve.name
}

# Create 'eve-group' IAM group
resource "aws_iam_group" "eve" {
  name = "eve-group"
  path = "/"
}

#IAM User Policies
resource "aws_iam_policy" "eve-policy" {
  name = "eve-policy"
  description = "eve-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": [
            "lambda:*", "s3:*", "ec2:*"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
    ]
}
EOF
}

# Attach policy to the eve-group
resource "aws_iam_group_policy_attachment" "eve" {
  group      = aws_iam_group.eve.name
  policy_arn = aws_iam_policy.eve-policy.arn
}

# Add eve to the group
resource "aws_iam_user_group_membership" "eve" {
  user = aws_iam_user.eve.name

  groups = [
    "${aws_iam_group.eve.name}",
  ]
}