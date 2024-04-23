pipeline {
  environment {
    ENVRMNT = "pdc"
    IMAGE_TAG_NAME = "ceetharamm/pyapp"+ ":$BUILD_NUMBER"
  }
  
  agent any
  
  stages {
    stage('Cloning Git') {
      steps {
        git credentialsId: 'GitCred', url: 'https://github.com/ceetharamm/cicd.git'
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
            dockerImage.push('latest')
            dockerImage.push()
            }
        }
      }
    }
    
    //stage('Remove Unused docker image') {
    //  steps{
    //    sh "docker rmi $IMAGE_TAG_NAME"
    //  }
    //}
    
    stage('Deploy App') {
      steps {
        script {
          // kubernetesDeploy(configs: "deployment.yaml", kubeconfigId: "dd-kube-config")
          withKubeConfig([credentialsId: 'dd-kube-config', serverUrl: 'https://kubernetes.docker.internal:6443']) {
            bat 'kubectl delete -f deployment.yaml'
            bat 'kubectl apply -f deployment.yaml'
          }
        }
      }
    }
    
  }
}
