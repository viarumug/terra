resource "aws_subnet" "public-subnet-1" {
  vpc_id     = "vpc-01abf249d39b75f32"
  cidr_block = "172.31.80.0/20"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

~                                                                                                                                                                                                          
~                                                                                                                                                                                                          
~                                                                                                                                                                                                          
~                                                                                                                                                                                                          
~                                                                                                                                                                                                          
~                             
