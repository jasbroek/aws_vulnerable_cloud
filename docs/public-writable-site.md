# Public Writable bucket
In this scenario the attacker replaces a bitcoin wallet address that is used for receiving donations.
This attack illustrates what can happen when there is public-write access on a bucket.
A more elaborate scenario would be a webshop importing static scripts from a bucket. An attacker can edit the script to export every form submission to an evil server.
This is one of the methods attackers use to place creditcard skimmers on webshops.

## Attack procedure
<details><summary>The steps to take</summary>

1. Browse to the URL of the writable bucket (given in Terraform output).
2. Notice that there is a BTC address for receiving donations.
3. Notice that the site is hosted on S3.
4. Using CLI sync the S3 bucket to your local machine (possible due to public read)
5. Edit the BTC address or anything else in `index.html`.
6. Upload the `index.html` file to the bucket with public read rights `aws s3 cp index.html s3://[bucket-name] --acl public-read-write`.

You can choose `public-read` or `public-read-write`. However if you use `public-read`, the owner of the bucket can not modify the file and might notice something is going on.
</details>