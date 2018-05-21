#
## Security Groups for Hackathon Pipeline
# 

resource "aws_security_group" "ssh_sg" {
  name        = "allow_ssh"
  description = "All SSH traffic"

  tags {
    Project = "hackathon_pipeline"
    Name    = "hackathon_sg_ssh"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http_sg" {
  name        = "allow_http"
  description = "All http traffic"

  tags {
    Project = "hackathon_pipeline"
    Name    = "hackathon_sg_http"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "https_sg" {
  name        = "allow_https"
  description = "All https traffic"

  tags {
    Project = "hackathon_pipeline"
    Name    = "hackathon_sg_https"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "allow_jenkins"
  description = "All jenkins traffic"

  tags {
    Project = "hackathon_pipeline"
    Name    = "hackathon_sg_jenkins"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins_agent" {
  name        = "jenkins_agent"
  description = "Jenkins agent port"

  tags {
    Project = "hackathon_pipeline"
    Name    = "hackathon_sg_jenkins_agent"
  }

  ingress {
    from_port   = 49187
    to_port     = 49187
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
