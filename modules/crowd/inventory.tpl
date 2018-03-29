[crowd]
${crowd_host}  ansible_connection=ssh  ansible_user=ec2-user

[crowd:vars]
postgresql_crowd_database='crowd'
