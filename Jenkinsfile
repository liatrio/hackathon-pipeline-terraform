pipeline {
  agent any
  stages {
    stage("Run Terraform") {
      steps {
        sh """
             if [ ! -d $JENKINS_HOME/hackathon_inventories ]; then
               mkdir $JENKINS_HOME/hackathon_inventories
             fi
           """
        sh "terraform init -input=false"
        sh "terraform apply -var \'inventories_location=$JENKINS_HOME/hackathon_inventories\' -auto-approve"
      }
    }
    stage("Run Ansible Playbooks") {
      steps {
        parallel (
          bitbucket: {
            dir('ansible-bitbucket') {
              git branch: 'master', url: 'https://github.com/liatrio/ansible-bitbucket.git'
            }
            sh "cp $JENKINS_HOME/hackathon_inventories/bitbucket.inventory ansible-bitbucket/inventory"
            sh "ansible-galaxy install liatrio.mount_persist_data"
            sh "ansible-galaxy install geerlingguy.git"
            sh "ansible-galaxy install ANXS.postgresql"
            sh "ansible-galaxy install geerlingguy.elasticsearch"
            sh "ansible-galaxy install geerlingguy.nginx"
            withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
              sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key $keyFileVariable -i ansible-bitbucket/inventory ./ansible-bitbucket/bitbucket.yml"
            }
          },
          jenkins_master: {
            dir('ansible-jenkins') {
              git branch: 'master', url: 'https://github.com/liatrio/ansible-jenkins.git'
            }
            sh "cp $JENKINS_HOME/hackathon_inventories/jenkins_master.inventory ansible-jenkins/inventory"
            sh "ansible-galaxy install liatrio.mount_persist_data"
            sh "ansible-galaxy install geerlingguy.jenkins"
            sh "ansible-galaxy install geerlingguy.git"
            sh "ansible-galaxy install geerlingguy.nginx"
            withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
              sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key $keyFileVariable -i  ansible-jenkins/inventory ./ansible-jenkins/jenkins_master.yml"
            }
          },
          sonarqube: {
            dir('ansible-sonarqube') {
              git branch: 'master', url: 'https://github.com/liatrio/ansible-sonarqube.git'
            }
            sh "cp $JENKINS_HOME/hackathon_inventories/sonarqube.inventory ansible-sonarqube/inventory"
            sh "ansible-galaxy install liatrio.mount_persist_data"
            sh "ansible-galaxy install geerlingguy.java"
            sh "ansible-galaxy install geerlingguy.mysql"
            sh "ansible-galaxy install geerlingguy.sonar"
            sh "ansible-galaxy install geerlingguy.nginx"
            withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
              sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key $keyFileVariable -i  ansible-sonarqube/inventory ./ansible-sonarqube/sonarqube.yml"
            }
          },
          crowd: {
            dir('ansible-crowd') {
              git branch: 'master', url: 'https://github.com/liatrio/ansible-crowd.git'
            }
            sh "cp $JENKINS_HOME/hackathon_inventories/crowd.inventory ansible-crowd/inventory"
            sh "ansible-galaxy install liatrio.mount_persist_data"
            sh "ansible-galaxy install geerlingguy.java"
            sh "ansible-galaxy install ANXS.postgresql"
            sh "ansible-galaxy install hudecof.atlassian-crowd"
            sh "ansible-galaxy install geerlingguy.nginx"
            withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
              withCredentials([usernamePassword(credentialsId: 'hackathon-crowd-postgres', passwordVariable: 'postgresPass', usernameVariable: 'postgresUser')]) {
                sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key $keyFileVariable --extra-vars \"postgresql_crowd_user=$postgresUser postgresql_crowd_password=$postgresPass\" -i ansible-crowd/inventory ./ansible-crowd/crowd.yml"
              }
            }
          },
          deployments: {
						dir('ansible-docker-nodes') {
							git branch: 'master', url: 'https://github.com/liatrio/ansible-docker-nodes.git'
						}
						sh "cp $JENKINS_HOME/hackathon_inventories/docker_nodes.inventory ansible-docker-nodes/inventory"
							withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
								sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key $keyFileVariable -i  ansible-docker-nodes/inventory ./ansible-docker-nodes/docker_nodes.yml"
							}
          },
          artifactory: {
            dir('ansible-artifactory'){
              git branch: 'master', url: 'https://github.com/liatrio/ansible-artifactory.git'
            }
            withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
              sh "echo hello"
            }
          },
          jira: {
            dir('ansible-jira') {
              git branch: 'master', url: 'https://github.com/liatrio/ansible-jira.git'
            }
            withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
              sh "echo hello"
            }
          },
          confluence: {
            dir('ansible-confluence') {
              git branch: 'master', url: 'https://github.com/liatrio/ansible-confluence.git'
            }
            withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
              sh "echo hello"
            }
          },
        )
      }
    }
    stage('setup Jenkins Agents'){
      steps {
          dir('ansible-jenkins-agents') {
            git branch: 'master', url: 'https://github.com/liatrio/ansible-jenkins-agents.git'
          }
          sh "cp $JENKINS_HOME/hackathon_inventories/jenkins_agents.inventory ansible-jenkins-agents/inventory"
          withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
            sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key $keyFileVariable -i  ansible-jenkins-agents/inventory ./ansible-jenkins-agents/jenkins_agents.yml"
          }
      }
    }
  }
}
