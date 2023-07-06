pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    // stage('Build and Publish') {
    //   steps {
    //     // Build and publish the Docker image using CloudBees Docker Build & Publish plugin
    //     dockerBuildAndPublish(credentialsId: 'docker_hub_credential',
    //                           cloudName: 'docker-hub',
    //                           imageTags: 'latest',
    //                           repoName: 'akeellegend/devops-test:tagname',
    //                           contextFolder: '.')
    //   }
    // }

    stage('Build and Publish') {
      steps {
        // Build the Docker image
        sh 'docker build -t akeellegend/devops-test:latest .'
        
        // Publish the Docker image to Docker Hub
        sh 'docker push akeellegend/devops-test:latest'
      }
    }

    stage('Deploy') {
        environment {
            // Set the environment variables for the deployment
            DOCKER_IMAGE = 'akeellegend/devops-test:latest'
            REMOTE_SERVER = '3.82.145.79'
            REMOTE_USER = 'ubuntu'
            REMOTE_PORT = '22'
            REMOTE_CONTAINER_NAME = 'devops-test'
            PORT_MAPPING = '5001:5001'
            KEY_CREDENTIALS = 'devops-key'
        }
        
        steps {
            // Stop and remove any existing container with the same name on the remote server
            sh "ssh-agent bash -c 'ssh-add /var/jenkins_home/devops-key; ssh -p $REMOTE_PORT -o StrictHostKeyChecking=no -i /var/jenkins_home/devops-key $REMOTE_USER@$REMOTE_SERVER \"docker stop $REMOTE_CONTAINER_NAME || true\"'"
            sh "ssh-agent bash -c 'ssh-add /var/jenkins_home/devops-key; ssh -p $REMOTE_PORT -o StrictHostKeyChecking=no -i /var/jenkins_home/devops-key $REMOTE_USER@$REMOTE_SERVER \"docker rm $REMOTE_CONTAINER_NAME || true\"'"
            
            // Run the Docker container with the published image on the remote server
            sh "ssh-agent bash -c 'ssh-add /var/jenkins_home/devops-key; ssh -p $REMOTE_PORT -o StrictHostKeyChecking=no -i /var/jenkins_home/devops-key $REMOTE_USER@$REMOTE_SERVER \"docker run -d -p $PORT_MAPPING --name $REMOTE_CONTAINER_NAME $DOCKER_IMAGE\"'"
        }
    }


    
  }
}
