# Public Readable bucket
This is a classical case of a public S3 bucket.
The S3 bucket is used to host a website, but the user has made the mistake of also uploading confidential files to the bucket. He thought this was an easy and convenient way to backup the files has he already had a bucket...

## Attack procedure
This scenario has two attack paths.

### Using a browser
<details><summary>The steps to take</summary>

1. Go to the public readable URL given in the Terraform output
2. Notice that this is a website URL, hosted on S3. We can replace `s3-website.[region]` with `s3` in the URL to get to the bucket.
3. Notice that there is a file called `Secret/secrets.txt`
4. add `Secrets/secrets.txt` to the URL and have the data.

Did you notice the `Authenticated/extra_secure_pii.csv` object? This can not be reached using the browser. It is only accessible for 'authenticated' users.
</details>

### Using CLI
<details><summary>The steps to take</summary>

1. Notice that the given website URL is hosted on S3 with bucket name `fc-web-bucket-[string]`.
2. In a terminal with AWS CLI installed, try to list the files in that bucket with `aws s3 ls s3://fc-web-bucket-[string]`.
3. Copy the S3 folder to your local machine `aws s3 sync s3://fc-web-bucket-[string]/ . ` and find the secrets.

If you have setup the AWS CLI to use your AWS account (e.g `aws configure`) you are an authenticated user. Authenticated users can access the `Authenticated/extra_secure_pii.csv` file. Which was setup with the `authenticated-read` permissions.
</details>
