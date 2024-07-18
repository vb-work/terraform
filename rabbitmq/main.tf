variable "rabbitmq_default_user" {
  description = "The default user for RabbitMQ"
  type        = string
}

variable "rabbitmq_default_pass" {
  description = "The default password for RabbitMQ"
  type        = string
}

variable "ssh_key_path" {
  description = "The path to private key"
  type        = string
}

resource "scaleway_instance_security_group" "rabbitmq_sg" {
  name = "rabbitmq-security-group"

  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action   = "accept"
    port     = "22"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }

  inbound_rule {
    action   = "accept"
    port     = "5672"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }

  inbound_rule {
    action   = "accept"
    port     = "15672"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
  }
}

resource "scaleway_instance_ip" "rabbitmq_ip" {
  tags = ["rabbitmq"]
}

resource "scaleway_instance_server" "rabbitmq" {
  name         = "rabbitmq-instance"
  type         = "DEV1-S"
  image        = "ubuntu_focal"
  tags         = ["rabbitmq"]

  security_group_id = scaleway_instance_security_group.rabbitmq_sg.id

  root_volume {
    size_in_gb = 20
  }

  ip_id = scaleway_instance_ip.rabbitmq_ip.id

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 -e RABBITMQ_DEFAULT_USER=${var.rabbitmq_default_user} -e RABBITMQ_DEFAULT_PASS=${var.rabbitmq_default_pass} rabbitmq:3-management"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_key_path)
      host        = self.public_ip
    }
  }
}

output "rabbitmq_instance_ip" {
  value = scaleway_instance_ip.rabbitmq_ip.address
}
