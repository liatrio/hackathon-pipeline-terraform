[jenkins_master]
${jenkins_master_host}  ansible_connection=ssh  ansible_user=ec2-user

[jenkins_master:vars]
jenkins_home=/data/jenkins

