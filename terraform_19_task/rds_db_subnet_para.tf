resource "aws_db_subnet_group" "rds_db_subnet" {
  name       = "mydb-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1.id,aws_subnet.private-subnet-2.id]
}



resource "aws_db_parameter_group" "paragroup" {
  name   = "paragroup"
  family = "mysql8.0"

 parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}
