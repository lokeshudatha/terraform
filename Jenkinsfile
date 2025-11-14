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
                    branch: 'feature'
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

        stage('Build Java Image') {
            steps {
                sh '''
                    docker build -t java_image:latest .
                '''
            }
        }

        stage('Push Java Image') {
            steps {
                sh '''
                    echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                    docker tag java_image:latest 9515524259/java_image:latest
                    docker push 9515524259/java_image:latest
                '''
            }
        }

        stage('Terraform Apply - Create VM') {
            steps {
                sh '''
                    sudo apt-get update -y
                    sudo apt-get install -y terraform

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
