pipeline {
    agent any

    environment {
        DOCKERHUB = credentials('docker-cred')   // contains username & password
        GCP_KEY   = credentials('gcp-key')       // contains service account JSON content
    }

    stages {

        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/lokeshudatha/repo.git',
                    credentialsId: 'git_cred',
                    branch: 'main'
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                sudo apt-get update -y
                sudo apt-get install -y unzip curl gnupg software-properties-common

                TERRAFORM_VERSION=1.5.7

                curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                sudo mv terraform /usr/local/bin/
                terraform version
                '''
            }
        }

        stage('Prepare GCP Credentials') {
            steps {
                sh '''
                echo "$GCP_KEY" > gcp-key.json
                '''
            }
        }

        stage('Terraform Apply - Create VM') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -var="credentials_file=../gcp-key.json" -auto-approve
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                sh '''
                # Build Docker image
                docker build -t python_image:latest .

                # Login to Docker Hub
                echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin

                # Tag image
                docker tag python_image:latest 9515524259/python_image:latest

                # Push image
                docker push 9515524259/python_image:latest
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline Completed"
        }
    }
}
