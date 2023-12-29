resource "aws_route_table" "pub_route_tb" {
  vpc_id = aws_vpc.hadiya_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-hadiya-product.id
  }
  tags = {
    Name = "pub_route_tb"
  }
}

resource "aws_route_table_association" "public-rt-association1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.pub_route_tb.id
}

resource "aws_route_table_association" "public-rt-association2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.pub_route_tb.id
}

