pipeline {
  environment {
    ENVRMNT = "pdc"
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git credentialsId: 'a7318ad5e558-gc', url: 'https://github.com/ceetharamm/cicd.git'
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build("pyimage")
        }
      }
    }
  }
}
