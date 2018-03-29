[bitbucket]
${bitbucket_host}  ansible_connection=ssh  ansible_user=ec2-user

[bitbucket:vars]
postgresql_bitbucket_database='bitbucket'
postgresql_bitbucket_user='bbuser'
postgresql_bitbucket_password='bbpass'
