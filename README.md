# AWS False Compliance Framework
This framework consists of a Terraform deployment for a vulnerable AWS cloud environment which is compliant* with CIS AWS foundations baseline and AWS best practices.

## Description 
This framework is developed during a master thesis research which aimed to find flaws in existing AWS security frameworks and baselines. The resources deployed comply* to the controls of the [CIS AWS foundations baseline v1.2](https://d1.awsstatic.com/whitepapers/compliance/AWS_CIS_Foundations_Benchmark.pdf) whilst still being vulnerable for attacks.

This scenario will deploy the following resources:
* 1x EC2 (including 1 VPC, 1 Security Group, 1 Snapshot and 1 Keypair)
* 4x S3 bucket with various configurations
* 2x Lambda function
* 3x IAM User: 
    1. `Alice` to be used in the [user-data](./docs/user-data.md) scenario
    2. `Bob` to be used in the [Data Injection](./docs/code-injection.md) scenario
    3. `Eve` to be discovered...
* 1x IAM Instance Role (for EC2)
* 3x IAM Role (Lambda and EC2)

The resources are intentionally vulnerable **DO NOT** deploy this in a production environment.

## Usage
Before running the steps below, make sure [Terraform](https://www.terraform.io/downloads.html) is installed on your machine.
Furthermore you need the AWS CLI with a profile configured with admin privileges.

**NOTE: This is still in development and might not work as expected**

1. Clone the repository
2. Rename `terraform.tfvars.example` to `terraform.tfvars` and set all the variables.
3. Run `./setup.sh` to create SSH keys. Alternatively, create the key manually `ssh-keygen -b 4096 -t rsa -f ./ssh_key -q -N ""` and put it in `assets/keys/`.
3. Run `terraform init`. 
Note: this installs the AWS terraform provider. However, the public-snapshot functionality is not supported nativly (yet) by Terraform. 
You can do either options below:
    * Comment out the last lines in the `ec2.tf` file, defining the `aws_snapshot_create_volume_permission`. Now the public snapshot will not be created.
    * Awaiting the merge of [this pull request](https://github.com/terraform-providers/terraform-provider-aws/pull/13231). To get this to work, one would need clone the [forked project](https://github.com/jasbroek/terraform-provider-aws) and [build the provider plugin](https://github.com/terraform-providers/terraform-provider-aws/blob/master/docs/DEVELOPMENT.md). This plugin can then be placed in `terraform/.terraform/plugins/[your os architecture]/`. Make sure to either overwrite the existing AWS plugin or rename the build plugin to a higher version number.

4. Run `terraform apply` to deploy the configuration
    <br>**Note:** This creates resources in your AWS account. **Charges may apply.**

When you want to destroy the resources, run `terraform destroy`.
This will **only** destroy resources created by Terraform. If you've created or altered resources outside Terraform, these will *not* be deleted. Please delete them manually using the AWS Management Console.

## Attack scenario's
The following scenario's are implemented in the framework.
Each scenario contains the exact steps required to exploit it.

* EC2
    * [SSRF Metadata exploit](docs/ssrf.md)
    * [Public snapsoht](docs/public-snapshot.md)
    * [User-data secrets](docs/user-data.md)
* Lambda
    * [Code injection](docs/code-injection.md)
    * [Secret Environment Vars](docs/secret-env-var.md)
* S3
    * [Public read permissions](docs/public-readable-site.md)
    * [Public write permissions](docs/public-writable-site.md)



## Disclaimer
No-brainer: **Do not deploy these resources in a production environment!**

Though this framework is developed with the best intentions and care in mind, usage is at your own risk. Mistakes may happen which result in AWS charges. To be sure, always double check if the created resources are deleted from the AWS account.

The created resources should be applicable for the AWS *free-tier*, however some charges may still apply.

\* Being compliant in the sense that all resources created comply with the recommendations. It does not make your entire AWS environment compliant. For instance CIS 2.5 (Ensure Config is enabled for all regions) will fail unless you have this service set-up in your account. The same holds for several IAM recommendations such as password policies. To achieve full compliance, manual steps need to be done.
