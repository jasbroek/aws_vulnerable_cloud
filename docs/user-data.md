# User Data 
In this attack scenario the importance of secret management is shown. There is secret data available in the user-data of an EC2 instance. The company thought this was a convenient way to distribute their code and give access to the private repositories.

## Attack procedure
This scenario has two attack paths.

### Using SSRF vulnerability
The simplest path for an outside attacker, making use of the SSRF vulnerability in a web application.

<details><summary>The steps to take</summary>

1. Discover the public IP or DNS name of the EC2 instance (given in Terraform output).
2. Exploit the metadataservice by issuing the following command to get the user-data
`http://169.254.169.254/latest/user-data`
3. Find AWS access and secret keys in the user-data, set this up locally in your AWS CLI
4. Discover that those keys give access to the secret S3 bucket.
</details>

### Inside attacker
Starting as an inside attacker with the credentials of Alice, you find your way into the EC2 instances and discover that the company uses `user-data` with some credentials inside.
<details><summary>The steps to take</summary>

1. Configure the AWS CLI with the credentials from Alice (given in Terraform output)
2. Describe the EC2 instances using `aws ec2 describe-instances --profile alice` and copy the instance ID of the machine.
3. Describe the instances user-data by using `aws ec2 describe-instance-attribute --instance-id [The instance ID] --attribute userData`. 
4. The return value is base64 encoded, decode it and you have cleartext user-data.
3. Find AWS access and secret keys in the user-data, set this up locally in your AWS CLI
4. Discover that those keys give access to the secret S3 bucket.
</details>