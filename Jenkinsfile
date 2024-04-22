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
          dockerImage = docker.build("ceetharamm/pyimage4"+ ":$BUILD_NUMBER")
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
            docker.withRegistry('', 'DockerCred') {
            dockerImage.push()
            }
        }
      }
    }
  }
}
