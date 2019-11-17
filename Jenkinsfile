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
         container('terraform') {
           sh 'terraform init'
           sh 'terraform plan -out myplan'
         }
       }
     }
    stage('TF Apply') {
      steps {
        container('terraform') {
          sh terraform apply -input=false myplan'
        }
      }
    }
  }
}
