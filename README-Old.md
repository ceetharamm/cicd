#

## Create Token in GIT
https://github.com/settings/apps
New fine-grained personal access token
Token name: GitCred
Token: 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

## Create Credentials for Docker Hub
Kind: Username with Password
Scope: Global
Username: ceetharamm
Password: Sr@131973
ID:DockerCred

## Create Credentials for Git 
Domain: Global credentials
Kind: Secret text
Scope: Global
Secret: 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
ID: GitCred

## Create Credentials for Kubernetes Cluster
Domain: Global credentials
Kind: Secret file
Scope: Global
File: C:\Users\Seetha\.kube\config-dd
ID: dd-kube-config

https://github.com/ceetharamm/cicd.git

https://www.cprime.com/resources/blog/how-to-integrate-jenkins-github/




## Installed Plugins
Kubernetes CLI Plugin			Version1.12.1

Docker plugin 					Version1.6
Kubernetes Credentials Plugin	Version0.11

Docker Pipeline					Version572.v950f58993843


# How to Deploy a Containerized Application to Kubernetes Cluster using Jenkins CI/CD Pipeline
you need to have the following:
1. Docker Desktop:
2. GitHub account:
3. Kubernetes Cluster:

## How to Deploy to Kubernetes Cluster using CI/CD Jenkins Pipeline `jenkins-kubernetes-deployment`
To deploy to Kubernetes Cluster using CI/CD Jenkins Pipeline, you will implement the following steps:

1. Run Jenkins as a Docker Container
1. Install Docker Pipeline Plugin
1. Install Kubernetes Plugin
1. Add Credentials to Jenkins Credentials Manager
1. Start Minikube
1. Create a new GitHub Repository
1. Create a Simple React.js application
1. Create a Dockerfile
1. Create a Kubernetes Deployment YAML file
1. Create a Kubernetes Service Deployment YAML file
1. Create a Jenkinsfile
1. Push the files to your GitHub repository
1. Create a Multi-branch Pipeline
1. Configure the Muliti-branch Pipeline
1. Build the Muliti-branch Pipeline
1. Accessing the deployed containerized application

#@ Step 1: Run Jenkins as a Docker Container

```
docker run --name myjenkins-container -p 8080:8080 -p 50000:50000 -v /var/jenkins_home jenkins

```
When you execute the command above:

It will run the jenkins official Docker image.
It will start the Jenkins container. It will then expose it on port 8080 and the nodes on port 50000. You will access the Jenkins container on port 8080.

Open your web browser and type http://localhost:8080 to access the Jenkins application:


Getting the administrator password
```
docker logs myjenkins-container
```


## Step 2: Install Docker Pipeline Plugin
To install Docker Pipeline Plugin, click Manage Jenkins >> Next, click Manage Plugins >> Next, search for Docker Pipeline. 
Then click the `Download now and install after restart button 

## Step 3: Install Kubernetes Plugin
To install the Kubernetes Plugin, you will search for Kubernetes Pipeline. 
Then click the `Download now and install after restart button:

## Step 4: Add Credentials to Jenkins Credentials Manager
You will add the GitHub and Docker Hub credentials to the Jenkins Credentials manager. Jenkins will use Git Hub credentials to authenticate to GitHub and Docker Hub credentials to authenticate to Docker Hub.

Adding the Docker Hub Credentials
Step 1: Go back to the Jenkins Dashboard and click Manage Jenkins
Step 2: Click "Manage Credentials"
Step 3: Click Add Credentials
Step 4: Select username with password and Add Docker Hub username and password

## Step 5: Start Minikube
```
minikube start
```

## Step 6: Create a new GitHub Repository
Create Public Repository with `jenkins-kubernetes-deployment`
You will push your Jenkinsfile, application files, and deployment files to the new GitHub repository. Let's start working on the application.



## Step 7: Create a Simple React.js application
In your computer, create a new folder named jenkins-deploy. In the jenkins-deploy folder, run the following command to create a simple React.js application:
```
npx create-react-app jenkins-kubernetes-deployment

```
The command will create a simple React.js application. It will also generate a new folder named jenkins-kubernetes-deployment inside the jenkins-deploy root folder.

## Step 8: Create a Dockerfile
jenkins-kubernetes-deployment/Dockerfile
```
#It will use node:19-alpine3.16 as the parent image for building the Docker image
FROM node:19-alpine3.16

#It will create a working directory for Docker. The Docker image will be created in this working directory.
WORKDIR /react-app

#Copy the React.js application dependencies from the package.json to the react-app working directory.
COPY package.json .

COPY package-lock.json .

#install all the React.js application dependencies
RUN npm i

<!-- Copy the remaining React.js application folders and files from the `jenkins-kubernetes-deployment` local folder to the Docker react-app working directory -->
COPY . .

#Expose the React.js application container on port 3000
EXPOSE 3000

#The command to start the React.js application container
CMD ["npm", "start"]
```

## Step 9: Create a Kubernetes Deployment file

jenkins-kubernetes-deployment/deployment.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment #The name of the Kubernetes Deployment to be created in the Kubernetes cluster
  labels:
    app: react-app
spec:
  replicas: 2 #The number of pods to be created in the Kubernetes cluster for the React.js application container
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app 
    spec:
      containers:
      - name: react-app #The name of the react.js application container
        image: ceetharamm/react-app:latest #The Docker image for building the React.js application container
        ports:
        - containerPort: 3000 #The port for the React.js application container
```

## Step 10: Create a Kubernetes Service Deployment YAML file
A Kubernetes Service Deployment YAML file will create a Kubernetes Service in the Kubernetes cluster. The Kubernetes Service will expose the pods for the React.js application container outside the Kubernetes cluster. You will use the Kubernetes Service to access the React.js application container from outside the Kubernetes cluster.

jenkins-kubernetes-deployment/service.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: service #The name of the Kubernetes Service to be created in the Kubernetes cluster
spec:
  selector:
    app: react-app 
  type: LoadBalancer #Type of the Kubernetes Service
  ports:
  - protocol: TCP
    port: 3000 #Service port
    targetPort: 3000 #The port for the React.js application container
```

## Step 11: Create a Jenkinsfile
jenkins-kubernetes-deployment/Jenkinsfile
```
pipeline {

  environment {
    dockerimagename = "bravinwasike/react-app"
    dockerImage = ""
  }

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git 'https://github.com/ceetharamm/jenkins-kubernetes-deployment.git'
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhub-credentials'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
          }
        }
      }
    }

    stage('Deploying React.js container to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(configs: "deployment.yaml", "service.yaml")
        }
      }
    }

  }

}
```

## Step 12: Push the Files to your GitHub Repository
After running the Git commands, you will push all the React.js application files, the Dockerfile, the Jenkinsfile, the deployment.yaml file, and the service.yaml file to your GitHub Repository:


## Step 13: Create a Multi-branch Pipeline


## Step 14: Configure the Multi-branch Pipeline


## Step 15. Build the Muliti-branch Pipeline


## Step 16: Accessing the Deployed Containerized Application
kubectl get service
- react-app-service
minikube service react-app-service





## 


