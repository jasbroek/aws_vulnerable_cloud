resource "aws_iam_user" "alice" {
  name          = "alice"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "alice" {
  user = aws_iam_user.alice.name
}


# Create 'alice-group' IAM group
resource "aws_iam_group" "alice" {
  name = "alice-group"
  path = "/"
}


#IAM User Policy
resource "aws_iam_policy" "alice-policy" {
  name = "alice-policy"
  description = "alice-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": [
            "ec2:DescribeInstances","ec2:DescribeVpcs", "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups", "ec2:DescribeInstanceAttribute"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
    ]
}
EOF
}

# Attach policy to the alice-group
resource "aws_iam_group_policy_attachment" "alice" {
  group      = aws_iam_group.alice.name
  policy_arn = aws_iam_policy.alice-policy.arn
}

# Add alice to the group
resource "aws_iam_user_group_membership" "alice" {
  user = aws_iam_user.alice.name

  groups = [
    "${aws_iam_group.alice.name}",
  ]
}