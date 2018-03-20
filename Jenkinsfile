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
      parallel (
        jenkins_master: {
          dir('jenkins_master') {
            git branch: 'master', url: 'https://github.com/liatrio/ansible-jenkins.git'
          }
          sh "cp $JENKINS_HOME/hackathon_inventories/modules/jenkins_master/inventory jenkins_master/inventory"
          withCredentials([file(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
            sh "eval $(ssh-agent) && ssh-add $keyFileVariable"
            sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i $JENKINS_HOME/hackathon_inventories/jenkins_master.inventory ./jenkins_master/ansible-jenkins/jenkins_master.yml"
          }
        },
        jenkins_agent: {
          dir('jenkins_agent') {
            git branch: 'master', url: 'https://github.com/liatrio/ansible-jenkins-agents.git'
          }
          withCredentials([file(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
            sh "eval $(ssh-agent) && ssh-add $keyFileVariable"
            sh "echo hello"
          }
        },
        bitbucket: {
          dir('bitbucket') {
            git branch: 'master', url: 'https://github.com/liatrio/ansible-artifactory.git'
          }
          withCredentials([file(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
            sh "eval $(ssh-agent) && ssh-add $keyFileVariable"
            sh "echo hello"
          }
        },
        artifactory: {
          dir('artifactory'){
            git branch: 'master', url: 'https://github.com/liatrio/ansible-jira.git'
          }
          withCredentials([file(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
            sh "eval $(ssh-agent) && ssh-add $keyFileVariable"
            sh "echo hello"
          }
        },
        jira: {
          dir('jira') {
            git branch: 'master', url: 'https://github.com/liatrio/ansible-bitbucket.git'
          }
          withCredentials([file(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
            sh "eval $(ssh-agent) && ssh-add $keyFileVariable"
            sh "echo hello"
          }
        },
        confluence: {
          dir('confluence') {
            git branch: 'master', url: 'https://github.com/liatrio/ansible-confluence.git'
          }
          withCredentials([file(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
            sh "eval $(ssh-agent) && ssh-add $keyFileVariable"
            sh "echo hello"
          }
        },
        sonarqube: {
          dir('sonarqube') {
            git branch: 'master', url: 'https://github.com/liatrio/ansible-sonarqube.git'
          }
          withCredentials([file(credentialsId: 'hackathon-key', keyFileVariable: 'keyFileVariable')]) {
            sh "eval $(ssh-agent) && ssh-add $keyFileVariable"
            sh "echo hello"
          }
        }
      )
    }
    stage("Clean workspace") {
      steps {
        deleteDir()
      }
    }
  }
}

