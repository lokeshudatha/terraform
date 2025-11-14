pipeline {
    agent any

    environment {
        DOCKERHUB = credentials('docker-cred')
        GCP_KEY = credentials('gcp-key')
    }

    stages {

        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/lokeshudatha/repo.git',
                    credentialsId: 'git_cred',
                    branch: 'main'
            }
        }

        stage('Auth GCP') {
            steps {
                sh '''
                    gcloud auth activate-service-account --key-file=$GCP_KEY
                    gcloud config set project winter-monolith-477705-m8
                '''
            }
        }

        stage('Build python Image') {
            steps {
                sh '''
                    docker build -t python_image:latest .
                '''
            }
        }

        stage('Push Python Image') {
            steps {
                sh '''
                    echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                    docker tag python_image:latest 9515524259/python_image:latest
                    docker push 9515524259/python_image:latest
                '''
            }
        }

        stage('Terraform Apply - Create VM') {
            steps {
                sh '''
                    sudo apt-get update && sudo apt-get install -y software-properties-common wget gnupg2 && wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && sudo apt update && sudo apt-get install -y terraform
                    cd terraform

                    terraform init

                    terraform apply \
                        -var="credentials_file=$GCP_KEY" \
                        -auto-approve
                '''
            }
        }
    }
}
