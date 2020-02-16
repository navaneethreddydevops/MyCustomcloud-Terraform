pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'cd webec2cluster'
      }
    }
    stage('TF Plan') {
       steps {
           sh '''
           /usr/local/bin/terraform init
           /usr/local/bin/terraform plan -out myplan
           '''
       }
     }
    stage('Approval') {	
      steps {	
        script {	
          def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])	
        }	
      }	
    }
    stage('TF Apply') {
      steps {
          sh 'terraform apply -input=false myplan'
      }
    }
  }
}
