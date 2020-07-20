# Public Snapshot
In this scenario, the attacker stumbles upon a public EBS snapshot containing confidential files. Though the snapshotID is given for convenience, there are [tools](https://github.com/BishopFox/dufflebag) available which scan AWS for public snapshots and can automatically extract secrets.

Having public snapshots is extremely dangerous as any data on the disk (even deleted data!) can be recovered.

## Attack procedure
<details><summary>The steps to take</summary>

To exploit the public snapshot, you need to create a seperate AWS account.
With this account you can mount the public snapshot in an EC2 instance you own and discover its contents.

1. Create a new EC2 instance from the AWS Console of another AWS account, choose any linux ami you prefer (Ubuntu or Amazon Linux).
2. On the volumes section, add an extra volume as `/dev/sdf` and input the snapshot ID given by the Terraform output in the Snapshot field. The public snapshot is should be visible and can be selected. To auto delete the extra volume when the instance gets terminated, please tick the box.
3. Launch the instance with a keypair you already have or create a new one.
4. SSH into your machine and mount the second volume as follows:
    1. Run `lsblk` to list all disks. The second disk should show as `xvdf1`
    2. Run `sudo mkdir /newvolume` to create a directory on which to mount the disk
    3. Run `sudo mount /dev/xvdf1 /newvolume/` to mount the disk
    4. Secret hunting time (`cat /newvolume/home/ubuntu/passwords.txt`)

</details>