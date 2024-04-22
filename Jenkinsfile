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
    
    stage('Push Image') {
      steps{
        script {
            docker.withRegistry('https://registry.hub.docker.com', 'DockerCred') {
            dockerImage.push("${env.BUILD_NUMBER}")
            dockerImage.push("latest")
            }
        }
      }
    }
    
  }
}
