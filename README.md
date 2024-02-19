# flask-devops-project

## Building and deploying a flask application using Doker, Jenkins and Kubernetes

## Configure Jenkins as a service --

## Follow path given on page - https://www.jenkins.io/blog/2022/12/27/run-jenkins-agent-as-a-service/
## Contents of start-agent.sh file -
## cd /home/devsidd/jenkins
## curl -sO http://192.168.1.8:8080/jnlpJars/agent.jar
## java -jar agent.jar -jnlpUrl http://192.168.1.8:8080/computer/Ubuntu%2Dnode/jenkins-agent.jnlp -secret 1ca4505451499654cb6680dc9796e411842dd5cc090ae1380a9d56990ead06ed -workDir "/home/devsidd/jenkins"
## exit 0

## Contents of jenkins-agent.service file -
## [Unit]
## Description=Jenkins Agent
## 
## [Service]
## User=devsidd
## ExecStart=/bin/bash /home/devsidd/jenkins/start-agent.sh
## Restart=always
## WorkingDirectory=/home/devsidd/jenkins
## 
## [Install]
## WantedBy=multi-user.target

## Updated pipeline script from SCM for my docker image in Jenkins -

## pipeline {
##    agent { label 'Ubuntu-node' }
##   
##    environment {
##        DOCKER_HUB_REPO = "siddmi0407/flask-hello-world"
##        CONTAINER_NAME = "flask-hello-world"
##  
##    }
##   
##    stages {
##        stage('Checkout') {
##            steps {
##                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/siddharth07-ui/flask-devops-project.git']]])
##            }
##        }
##        stage('Build') {
##            steps {
##                echo 'Building..'
##                sh 'docker image build -t $DOCKER_HUB_REPO:latest .'
##            }
##        }
##        stage('Testing 1 - Pytest') {
##            steps {
##                echo 'Testing..'
##                sh 'docker stop $CONTAINER_NAME || true'
##                sh 'docker rm $CONTAINER_NAME || true'
##                sh 'docker run --name $CONTAINER_NAME $DOCKER_HUB_REPO python -m pytest test.py'
##            }
##        }
##        stage('Testing 2 - Flake8') {
##            steps {
##                echo 'Testing..'
##                sh 'docker stop $CONTAINER_NAME || true'
##                sh 'docker rm $CONTAINER_NAME || true'
##                sh 'docker run --name $CONTAINER_NAME $DOCKER_HUB_REPO python -m flake8'
##            }
##        }
##        stage('Deploy') {
##            steps {
##                echo 'Deploying....'
##                sh 'docker stop $CONTAINER_NAME || true'
##                sh 'docker rm $CONTAINER_NAME || true'
##                sh 'docker run -d -p 5000:5000 --name $CONTAINER_NAME $DOCKER_HUB_REPO'
##            }
##        }
##    }
## }

# Installed minikube on local computer (Ubuntu) using below link -
## https://minikube.sigs.k8s.io/docs/start/

# Adding 'deployment.yaml' and 'service.yaml' file to project using below logic -

## Create a new file named "deployment.yaml" in your project and add the below code.
## 
## apiVersion: apps/v1
## kind: Deployment
## metadata:
##  name: flask-hello-deployment # name of the deployment
##  
## spec:
##  template: # pod defintion
##    metadata:
##      name: flask-hello # name of the pod
##      labels:
##        app: flask-hello
##        tier: frontend
##    spec:
##      containers:
##        - name: flask-hello
##          image: shivammitra/flask-hello-world:latest
##  replicas: 3
##  selector: # Mandatory, Select the pods which needs to be in the replicaset
##    matchLabels:
##      app: flask-hello
##      tier: frontend
## 
## Test the deployment manually by running the following command:
## 
## $ kubectl apply -f deployment.yaml
## deployment.apps/flask-hello-deployment created
## $ kubectl get deployments flask-hello-deployment
## NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
## flask-hello-deployment   3/3     3            3           45s
## 
## Create a new file named "service.yaml" and add the following code
## 
## apiVersion: v1
## kind: Service
## metadata:
##  name: flask-hello-service-nodeport # name of the service
##  
## spec:
##  type: NodePort # Used for accessing a port externally
##  ports:
##    - port: 5000 # Service port
##      targetPort: 5000 # Pod port, default: same as port
##      nodePort: 30008 # Node port which can be used externally, default: auto-assign any free port
##  selector: # Which pods to expose externally ?
##    app: flask-hello
##    tier: frontend
## 
## Test the service manually by running below commands.
## 
## $ kubectl apply -f service.yaml
## service/flask-hello-service-nodeport created
## $ kubectl get service flask-hello-service-nodeport
## NAME                           TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
## flask-hello-service-nodeport   NodePort   10.110.46.59   <none>        5000:30008/TCP   36s
## 
## Run below command to access the application on the browser.
## 
## minikube service flask-hello-service-nodeport
