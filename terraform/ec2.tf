# AWS Key Pair
resource "aws_key_pair" "fc-ec2_key_pair" {
  key_name = "ec2_key_pair-${var.unique_id}"
  public_key = file(var.ssh_public_key)
}

# AWS EC2 instance creation
resource "aws_instance" "fc-ubuntu-18" {
  ami = data.aws_ami.ubuntu-18-server.id
  instance_type = "t2.micro"
  root_block_device {
        volume_type = "gp2"
        volume_size = 8
        delete_on_termination = true
  }
  associate_public_ip_address = true
  key_name = aws_key_pair.fc-ec2_key_pair.key_name
  iam_instance_profile = aws_iam_instance_profile.profile_for_ec2_ubuntu.name

  # Place EC2 inside VPC subnet
  subnet_id = aws_subnet.fc-public-subnet-1.id

  # Set security groups
  vpc_security_group_ids = [
        "${aws_security_group.fc-ubuntu-18-sg.id}",
    ]

  provisioner "file" {
      source = "../assets/scripts/ssrf/index.php"
      destination = "/home/ubuntu/index.php"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file(var.ssh_private_key)
        host = self.public_ip
      }
  }

  provisioner "file" {
      source = "../assets/files/secrets.txt"
      destination = "/home/ubuntu/passwords.txt"
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file(var.ssh_private_key)
        host = self.public_ip
      }
  }
  
  user_data = <<-EOF
      #!/bin/bash
      export GITHUB_KEY="some secret key to confidential repo"
      export GITHUB_REPO="https://github.com/companyname/some-confidential-private-repo"
      export admin_acces = "${aws_iam_access_key.eve.id}"
      export admin_secret = "${aws_iam_access_key.eve.secret}"
      sudo apt-get update
      sudo apt-get install apache2 php libapache2-mod-php -y
      sudo rm /var/www/html/index.html
      sudo cp /home/ubuntu/index.php /var/www/html/index.php  
  EOF
  
  tags = {
    Name = "fc-ubuntu-18"
  }

  volume_tags = {
    Name = "False Compliance ec2 ubuntu 18 disk"
  }
}

# Create a delay for the snapshot to be created, such that all files are on the machine
resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_instance.fc-ubuntu-18]

  create_duration = "30s"
}

# Create a public snapshot of the instance root volume
resource "aws_ebs_snapshot" "ubuntu18_public_snapshot" {
  volume_id = aws_instance.fc-ubuntu-18.root_block_device[0].volume_id
  description = "This is my snapshot, containing super secret stuff"

  tags = {
    Name = "Public Snapshot",
  }
  # Create the depend relationship, such that the snapshot waits 40s before creation
  depends_on = [time_sleep.wait_30_seconds]
}

# Create public snapshot, need adjusted TF AWS provider
resource "aws_snapshot_create_volume_permission" "public" {
  snapshot_id = aws_ebs_snapshot.ubuntu18_public_snapshot.id
  group  = "all"
}