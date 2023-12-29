resource "aws_db_instance" "hadiya" {
   allocated_storage   = 10
   storage_type        = "gp2"
   identifier          = "rdstf"
   engine              = "mysql"
   engine_version      = "8.0.33"
   instance_class      = "db.t2.micro"
   username            = "admin"
   password            = "Passw0rd!123"
   parameter_group_name = aws_db_parameter_group.paragroup.name
   vpc_security_group_ids = [aws_security_group.private-sg.id]
   db_subnet_group_name = aws_db_subnet_group.rds_db_subnet.name
   skip_final_snapshot = true

   tags = {
     Name = "MyRDS"
   }
 }
