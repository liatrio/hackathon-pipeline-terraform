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
          artifactory: {
            dir('ansible-artifactory'){
              git branch: 'PA-55-ansible-playbook', url: 'https://github.com/liatrio/ansible-artifactory.git'
            }
            sh "cp $JENKINS_HOME/hackathon_inventories/artifactory.inventory ansible-artifactory/inventory"
            sh "ansible-galaxy install liatrio.mount_persist_data"
            sh "ansible-galaxy install geerlingguy.java"
            sh "ansible-galaxy install geerlingguy.mysql"
            sh "ansible-galaxy install geerlingguy.nginx"
            sh "ansible-galaxy install bbaassssiiee.artifactory"
            withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
              sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key $keyFileVariable -i  ansible-artifactory/inventory ./ansible-artifactory/artifactory.yml"
            }
          }
          //jenkins_agent: {
          //  dir('ansible-jenkins-agent') {
          //    git branch: 'master', url: 'https://github.com/liatrio/ansible-jenkins-agents.git'
          //  }
          //  withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
          //    sh "echo hello"
          //  }
          //},
          //bitbucket: {
          //  dir('ansible-bitbucket') {
          //    git branch: 'master', url: 'https://github.com/liatrio/ansible-bitbucket.git'
          //  }
          //  withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
          //    sh "echo hello"
          //  }
          //},
          //jira: {
          //  dir('ansible-jira') {
          //    git branch: 'master', url: 'https://github.com/liatrio/ansible-jira.git'
          //  }
          //  withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
          //    sh "echo hello"
          //  }
          //},
          //confluence: {
          //  dir('ansible-confluence') {
          //    git branch: 'master', url: 'https://github.com/liatrio/ansible-confluence.git'
          //  }
          //  withCredentials([sshUserPrivateKey(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
          //    sh "echo hello"
          //  }
          //},
        )
      }
    }
  }
}

