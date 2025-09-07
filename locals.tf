locals {
  ami_map = {
    amazon_linux = data.aws_ami.amazon_linux.id
    ubuntu       = data.aws_ami.ubuntu.id
    redhat       = data.aws_ami.redhat.id
  }

  #used generated key
  /* keypair_map = {
    amazon_linux = data.aws_key_pair.amazon_linux.key_name
    ubuntu       = data.aws_key_pair.ubuntu.key_name
    redhat       = data.aws_key_pair.redhat.key_name
  } */

  user_data = {
    amazon_linux = <<-EOT
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<html>
    <head>
    <title>Welcome to My Web Server</title>
    </head>
    <body>
    <h1>Hello World from $(hostname -f)</h1>
    <p>This is Apache running on Amazon Linux</p>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
    </body>
    </html>" > /var/www/html/index.html
    EOT


    ubuntu = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "<html>
    <head>
    <title>Welcome to My Web Server</title>
    </head>
    <body>
    <h1>Hello World from $(hostname -f)</h1>
    <p>This is Apache running on ubuntu
    </p>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
    </body>
    </html>" > /var/www/html/index.html
    EOT

    redhat = <<-EOT
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<html>
    <head>
    <title>Welcome to My Web Server</title>
    </head>
    <body>
    <h1>Hello World from $(hostname -f)</h1>
    <p>This is Apache running on Redhat
    </p>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
    </body>
    </html>" > /var/www/html/index.html
    EOT
  }

}
