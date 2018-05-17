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
        sh "terraform destroy -var \'inventories_location=$JENKINS_HOME/hackathon_inventories\' -auto-approve"
      }
    }
  }
}
