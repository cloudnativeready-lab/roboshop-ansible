git pull 
ansible-playbook -i ../hosts roboshop.yml -e ansible_user=ec2-user -e ansible_password=DevOps321 -e role_name=${role_name}