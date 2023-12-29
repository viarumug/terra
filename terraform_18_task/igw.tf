#igw for vpc

resource "aws_internet_gateway" "igw-hadiya-product" {
  vpc_id = aws_vpc.hadiya_vpc.id

  tags = {
    Name = "igw-hadiya-product"
  }
}
