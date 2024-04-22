pipeline {
  environment {
    ENVRMNT = "pdc"
    IMAGE_TAG_NAME = "ceetharamm/pyimage4"+ ":$BUILD_NUMBER"
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
          dockerImage = docker.build("$IMAGE_TAG_NAME")
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
    
    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "deployment.yaml", kubeconfigId: "dd-kube-config")
        }
      }
    }
    
  }
}
