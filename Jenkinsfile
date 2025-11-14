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
            # Install Terraform without sudo
            wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
            unzip terraform_1.5.7_linux_amd64.zip
            chmod +x terraform
            mv terraform /usr/local/bin/ || true

            # Move into terraform folder inside repo
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
