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

