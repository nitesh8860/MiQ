# MiQ Case study 
1. Create a VPC (192.168.1.0/24) 
Completed
2. with 2 subnets  (192.168.1.0/25 and 192.168.1.128/25) in any region. 
Completed
3. Make one Subnet as Private and other one as Public. 
Completed
3. Add 2 instances, one in Public and one in Private. 
Completed
4. create a load balancer in public subnet and add private subnet instance as node to it at port 80:80

5. Then, create a docker nginx container with ‘HELLO DOCKER’ content in the Private Instance 

6. and that docker container should be accessible with a Load Balancer URL.



#Creating SSH Key pair
ssh-keygen -t rsa -b 2048 -f ~/.ssh/MyKeyPair.pem -q -P ''
chmod 400 ~/.ssh/MyKeyPair.pem
ssh-keygen -y -f ~/.ssh/MyKeyPair.pem > ~/.ssh/MyKeyPair.pub

MyKeyPair.pem will be used to create access from ansible to servers to deploy containers
IP of server can be seen from outputs of terraform run with "ec2_instance_private_ips" name

Run:
1. terraform init
2. terraform validate
3. terraform apply
4. ansible-playbook ansible/playbook.yml -e server=module.ec2_instances_private.private_ip -u ec2-user
