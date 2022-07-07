module "ec2_instance1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  user_data = <<EOF
#!/bin/sh
sudo apt-get update -y
sudo apt-get install ca-certificates -y
sudo apt-get install curl -y
sudo apt-get install gnupg -y
sudo apt-get install lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null -y
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
apt-cache madison docker-ce
sudo chmod 666 /var/run/docker.sock
docker run -d -p 5000:5000 1528762/webapp:2.0
EOF

  name = "webapp:3.1"

  ami                    = "ami-052efd3df9dad4825" ## Copy and paste the ami id
  instance_type          = "t2.micro"
  key_name               = "kennix" ## copy and paste the key
  monitoring             = true
  iam_instance_profile = "ec2-ssm-role"
  vpc_security_group_ids = ["sg-05a7e5860f62cbcc2"] #copy and paste the SG
  subnet_id              = "subnet-0285abf46a573380c" #copy and paste the subnet

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}