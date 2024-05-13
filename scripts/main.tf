resource "aws_instance" "k8s-master" {
  ami           = "ami-04ff98ccbfa41c9ad" 
  instance_type = "t2.micro" 
  key_name = "capstone"
  vpc_security_group_ids= ["sg-0318e2779e30d05ec"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./capstone.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "k8s-master"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.k8s-master.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Banking/scripts/finance-playbook.yml "
  } 
}
