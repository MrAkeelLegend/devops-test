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

    
  }
}
