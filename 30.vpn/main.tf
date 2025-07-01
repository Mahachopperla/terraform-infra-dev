resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("C:\\devops\\keys\\openvpn.pub") 
}
#above block will import the public key present in ur system to aws portal

resource "aws_instance" "vpn" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id     = local.public_subnet_id
  key_name = aws_key_pair.openvpn.key_name #we are placing imported key in vpn server. so this server can be access by private key which we created.
  user_data = file("openvpn.sh") # this user_data will automatically run script that is porvided to it once instance is created. it doesn't need authentication. as we know user_data not require authentication it automatically installs script upon instance creation. 

  

  tags = merge(
    local.common_Tags,
    {
        Name = "${var.project}-${var.environment}-vpn"
    }
  )
}