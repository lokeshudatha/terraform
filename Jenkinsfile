pipeline {
    agent any

    environment {
        DOCKERHUB = credentials('docker-creds')  
    }

    stages {

        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/lokeshudatha/repo.git',
                    credentialsId: 'git_creds',
                    branch: 'main'
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                sudo -i
                apt-get update -y
                apt-get install -y unzip curl gnupg software-properties-common

                TERRAFORM_VERSION=1.5.7

                curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                mv terraform /usr/local/bin/
                terraform version
                '''
            }
        }
        stage('Terraform Apply - Create VM') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply --auto-approve
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                sh '''
                # Build Docker image
                docker build -t python_img:latest .

                # Login to Docker Hub
                echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin

                # Tag image
                docker tag python_img:latest 9515524259/python_img:latest

                # Push image
                docker push 9515524259/python_img:latest
                '''
            }
        }
    }
}
