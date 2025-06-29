default:
		git pull
		ansible-playbook -i $(role_name)-dev.shr-eng.com, roboshop.yml -e ansible_user=ec2-user -e ansible_password=DevOps321 -e role_name=$(role_name)
		# command place vita role