#private route table with association

resource "aws_route_table" "pvt_route_tb" {
  vpc_id = aws_vpc.hadiya_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "pvt_route_tb"
  }
}
resource "aws_route_table_association" "private-rt-association1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.pvt_route_tb.id
}

resource "aws_route_table_association" "private-rt-association2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.pvt_route_tb.id
}
