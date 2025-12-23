provider "aws" {
  region = "ap-south-1"
}

# ---------------- S3 bucket for Terraform state ----------------
resource "aws_s3_bucket" "tf_state" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "${var.Project_name}-tf-state-bucket"
  }
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ---------------- VPC ----------------
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.Project_name}-vpc"
  }
}

# ---------------- Internet Gateway ----------------
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.Project_name}-igw"
  }
}

# ---------------- Subnets ----------------
resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.pub_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.Project_name}-public-subnet"
  }
}

resource "aws_subnet" "pvt_subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.pvt_cidr
  availability_zone = var.az1

  tags = {
    Name = "${var.Project_name}-private-subnet-1"
  }
}

resource "aws_subnet" "pvt_subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.pvt_cidr2
  availability_zone = var.az2

  tags = {
    Name = "${var.Project_name}-private-subnet-2"
  }
}

# ---------------- Route Table ----------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.Project_name}-public-rt"
  }
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------- EC2 Security Group ----------------
resource "aws_security_group" "ec2_sg" {
  name   = "${var.Project_name}-ec2-sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.Project_name}-ec2-sg"
  }
}

# ---------------- EC2 Instances ----------------
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.pub_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_pair

  tags = {
    Name = "web-server"
  }
}

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.pub_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_pair

  tags = {
    Name = "app-server"
  }
}

# ---------------- RDS Security Group ----------------
resource "aws_security_group" "rds_sg" {
  name   = "${var.Project_name}-rds-sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.Project_name}-rds-sg"
  }
}

# ---------------- RDS Subnet Group ----------------
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${var.Project_name}-rds-subnet-group"

  subnet_ids = [
    aws_subnet.pvt_subnet1.id,
    aws_subnet.pvt_subnet2.id
  ]

  tags = {
    Name = "${var.Project_name}-rds-subnet-group"
  }
}

# ---------------- RDS MySQL Instance ----------------
resource "aws_db_instance" "mysqlrds" {
  identifier             = "ansible-3-tier-mysql"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible    = false
  skip_final_snapshot    = true
}

