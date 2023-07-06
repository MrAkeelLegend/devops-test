cat /etc/group | grep docker
docker image build -t custom-jenkins-docker .
docker run -d -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v /var/jenkins_home:/var/jenkins_home custom-jenkins-docker