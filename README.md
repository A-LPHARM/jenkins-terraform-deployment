# jenkins-terraform-deployment

prepare your docker file with docker in docker image created 
the docker file should install terraform in the root image and also install wget and unzip once done 
follow the instructions from the jenkins documentation
https://www.jenkins.io/doc/book/installing/docker/
1. create a network 
 using jenkins 
# docker network create jenkins
2. create the docker image 
    this is the docker in dind that will connect to the jenkins and acts as the node
<!-- docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2 -->

3. customize your dockerfile with terraform pre-installed in the root 
<!-- FROM jenkins/jenkins:2.414.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release && apt-get install -y wget unzip
RUN apt-get update && apt-get install -y \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip -d /usr/local/bin \
    && rm terraform.zip 
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow" -->

then run

<!-- docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins  -->

once the jenkins is running 
exec into the container and 
# docker exec -t <container-id> sh

then 
# cat var/jenkins_home/secrets/initialAdmin/Password

on the console 

install the plugin 

terraform plugin

and aws credentials plugin

move to the manage 
click on tools 

then install the terraform plugin 
which have been pre-installed 
add the path to the terraform