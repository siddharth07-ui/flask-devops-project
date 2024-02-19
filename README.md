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

