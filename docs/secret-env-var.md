# Secret Environment Variables
In this scenario, you start as user Bob which has read access on Lambda functions.
One of the Lambda function has improper secret management, which allows you to escalate your privileges to get access to the S3 bucket containing secrets.

## Attack procedure
<details><summary>The steps to take</summary>

1. List all lambda functions using `aws lambda list-functions`
2. Notice the credentials in the Environment variables of the `lambda-admin-test` function
3. Use these credentials in AWS CLI to discover that you have full S3, EC2 and Lambda permissions.
4. Discover the secret S3 bucket.
</details>