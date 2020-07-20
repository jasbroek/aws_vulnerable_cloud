resource "aws_flow_log" "example" {
  iam_role_arn    = aws_iam_role.fc-flow-log-cloudwatch-role.arn
  log_destination = aws_cloudwatch_log_group.fc-cloudwatch-group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.fc-vpc.id
}

resource "aws_cloudwatch_log_group" "fc-cloudwatch-group" {
  name = "False_Compliance_group"
}

resource "aws_iam_role" "fc-flow-log-cloudwatch-role" {
  name = "FCFlowlogCloudwatchRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch-role-policy" {
  name = "CloudwatchPolicy"
  role = aws_iam_role.fc-flow-log-cloudwatch-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
