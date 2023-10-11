STEPS TO FOLLOW IN SETTING UP 

# Jenkins Terraform Deployment

This guide explains how to prepare a Dockerfile that includes Docker in Docker (DinD) and installs Terraform within the root image. Follow the Jenkins documentation at [Jenkins Docker Installation](https://www.jenkins.io/doc/book/installing/docker/) for reference.

1. **docker-compose**
    you can use the docker compose file already created 
    then run 
    ```shell 
    docker compose up -d --build
    ```
    this builds the entire dockerfile and docker-compose file to create your jenkins server necessary to implement your terraform deployment then you configure your jenkins or follow this steps for manual installation

2. **Create a Network**

   First, create a Docker network for Jenkins:

   ```shell
   docker network create jenkins
   ```

3. **Create the Docker Image**

   Create a Docker image for DinD to act as a Jenkins node:

   ```shell
   docker run --name jenkins-docker --rm --detach \
     --privileged --network jenkins --network-alias docker \
     --env DOCKER_TLS_CERTDIR=/certs \
     --volume jenkins-docker-certs:/certs/client \
     --volume jenkins-data:/var/jenkins_home \
     --publish 2376:2376 \
     docker:dind --storage-driver overlay2
   ```

4. **Customize Your Dockerfile**

   Customize your Dockerfile to include Terraform pre-installed in the root image. You can use the following example:

   ```Dockerfile
   FROM jenkins/jenkins:2.414.2-jdk17
   USER root
   RUN apt-get update && apt-get install -y lsb-release && apt-get install -y wget unzip
   # Install Terraform
   RUN apt-get update && apt-get install -y unzip
   && curl -fsSL https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -o terraform.zip
   && unzip terraform.zip -d /usr/local/bin
   && rm terraform.zip
   RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
     https://download.docker.com/linux/debian/gpg
   RUN echo "deb [arch=$(dpkg --print-architecture) \
     signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
     https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
   RUN apt-get update && apt-get install -y docker-ce-cli
   USER jenkins
   RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
   ```

   Build the Docker image:

   ```shell
   docker build -t jenkins .
   ```

5. **Start Jenkins**

   Start Jenkins with the Docker image:

   ```shell
   docker run --name jenkins --restart=on-failure --detach \
     --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
     --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
     --publish 8080:8080 --publish 50000:50000 \
     --volume jenkins-data:/var jenkins_home \
     --volume jenkins-docker-certs:/certs/client:ro \
     myjenkins-blueocean:2.414.2-1
   ```

6. **Initial Setup**

   Once Jenkins is running, access the container:

   ```shell
   docker exec -it <container-id> sh
   ```

   Retrieve the initial admin password:

   ```shell
   cat /var/jenkins_home/secrets/initialAdmin/Password
   ```

   Follow the [Jenkins installation guide](https://www.jenkins.io/doc/book/installing/docker/) for detailed setup instructions.

7. **Install Plugins**

   Install the required Jenkins plugins, including the Terraform plugin and AWS credentials plugin, via the Jenkins web interface. Add your AWS credentials in Jenkins.

8. **Build the Pipeline**

   Create a new pipeline by following these steps:

   - Click on "New Item."
   - Select "Pipeline."
   - Use the following pipeline script:

     ```groovy
     pipeline {
         agent any

         environment {
             AWS_DEFAULT_REGION='us-east-1'
             AWS_CREDENTIALS = credentials('awscred') 
         }

         stages {
             stage('git clone') {
                 steps {
                     git branch: 'main', url: 'https://github.com/A-LPHARM/jenkins-terraform-deployment'
                 }
             }

             stage('terraform init') {
                 steps {
                     sh 'pwd'
                     sh 'terraform init -reconfigure'
                 }
             }

             stage('terraform plan') {
                 steps {
                     sh 'terraform plan'
                 }
             }

             stage('terraform action') {
                 steps {
                     echo "terraform action is --> ${action}"
                     sh 'terraform {action} --auto-approve'
                 }
             }
         }
     }
     ```

   In the pipeline script, integrate Git cloning, authentication with AWS credentials, and script commands for Terraform actions.

   - For Terraform `apply` and `destroy`, use a parameter to specify the action:

     ```groovy
     stage('terraform action') {
         steps {
             echo "terraform action is --> ${action}"
             sh 'terraform {action} --auto-approve'
         }
     }
     ```

   In the parameters section, use the `action` tag for easy Terraform apply and destroy.

Follow these steps to set up your Jenkins environment for Terraform deployments. Thank you!