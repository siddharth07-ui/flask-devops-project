def FAILED_STAGE

pipeline {
   agent any
  
   environment {
       DOCKER_HUB_REPO = "siddmi0407/flask-hello-world"
       CONTAINER_NAME = "flask-hello-world"
       DOCKERHUB_CREDENTIALS=credentials('dockerhub')
   }
  
   stages {
       /* We do not need a stage for checkout here since it is done by default when using "Pipeline script from SCM" option. */
      
       stage('Build') {
           steps {
               script {
                   FAILED_STAGE=env.STAGE_NAME
                   echo 'Building..'
                   sh 'docker image build -t $DOCKER_HUB_REPO:latest .'
               }
           }
       }
       stage('Test') {
           steps {
               script {
                   FAILED_STAGE=env.STAGE_NAME
                   echo 'Testing..'
                   sh 'docker stop $CONTAINER_NAME || true'
                   sh 'docker rm $CONTAINER_NAME || true'
                   sh 'docker run --name $CONTAINER_NAME $DOCKER_HUB_REPO /bin/bash -c "pytest test.py && flake8"'
               }
           }
       }
       stage('Push') {
           steps {
               script {
                   FAILED_STAGE=env.STAGE_NAME
                   echo 'Pushing image..'
                   sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                   sh 'docker push $DOCKER_HUB_REPO:latest'
               }
           }
       }
       stage('Deploy') {
           steps {
               script {
                   FAILED_STAGE=env.STAGE_NAME
                   echo 'Deploying....'
                   kubernetesDeploy(configs: "deployment.yaml", "service.yaml")
               }
           }
       }
   }
   post {
        failure {
            echo "Failed stage name: ${FAILED_STAGE}"
        }
    }
}