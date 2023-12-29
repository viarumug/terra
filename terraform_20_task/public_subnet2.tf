resource "aws_subnet" "public-subnet-2" {
  vpc_id     = "vpc-01abf249d39b75f32"
  cidr_block = "172.31.96.0/20"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}
~                                                                                                                                                                                                          
~            
