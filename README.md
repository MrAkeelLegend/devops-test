# DevOps Test Repository

This repository contains code for a DevOps test project. It includes a Flask Cognito application along with main.tf file for infrastructure provisioning & Jenkinsfile for CI/CD pipeline automation.

live project demo website available on below url:
[flask cognito auth simple app](http://3.82.145.79:5001/)

#####Routes
- http://3.82.145.79:5001/
- http://3.82.145.79:5001/login
- http://3.82.145.79:5001/register
- http://3.82.145.79:5001/members

## Project artifacts link

1. Docker Repo -  [akeellegend/devops-test/](https://hub.docker.com/repository/docker/akeellegend/devops-test/)

2. Github Repo - [MrAkeelLegend/devops-test](https://github.com/MrAkeelLegend/devops-test/tree/main)



## Project Structure

The repository is structured as follows:

- `app.py`: Flask application file that implements a simple web application.
- `requirements.txt`: Text file listing the Python dependencies required by the Flask application.
- `Dockerfile`: Dockerfile for building a Docker image of the Flask application.
- `Jenkinsfile`: Jenkinsfile defining the CI/CD pipeline stages for the project.
- `main.tf`: terraform config file to create AWS resources for the infrastructure & services provisioning and configuring.



## Getting Started

To run and deploy the Flask Cognito application using the CI/CD pipeline, follow these steps:

##### 1. Clone the repository to your local machine using the following command: {#1}

`git clone https://github.com/MrAkeelLegend/devops-test.git`

##### 2. create a python venv virtual environment and activate it for better manage python dependencies if you want to run locally (optional) {#1}

```
python3 -m venv myenv
source venv/bin/activate
```

##### 3. run following command respectively to initialize terraform registry audit and provision services in AWS (you should configure aws cli first in order to run those terraform configs)

```
terraform init
terraform plan
terraform apply
```

##### 4. spin up a jenkins container to run the pipelines using following commands

```
cd jenkins_docker
docker image build -t custom-jenkins-docker .
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins-docker -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home:/var/jenkins_home custom-jenkins-docker
```

==Note==: I've added a customized jenkins image on top of jenkins/jenkins official image in order to access docker host native docker socket to execute docker command inside jenkins container

5. create a pipeline project in jenkins and select pipeline from scm option and add the repo url, as jenkins will pick the pipeline from the **Jenkinsfile** reside in the project root directory

6. feel free to change the credentials as it fits to yours



