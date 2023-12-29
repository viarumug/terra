#private sub_net

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.hadiya_vpc.id
  cidr_block = "10.0.7.0/24"
  availability_zone = "us-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.hadiya_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-2"
  }
}

