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
            # Download terraform zip
            wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip

            # Extract terraform binary without unzip
            # Zip file contains 1 binary at the end; grep offset and cut it out
            offset=$(grep -aob 'PK' terraform_1.5.7_linux_amd64.zip | head -n1 | cut -d: -f1)
            tail -c +$((offset+1)) terraform_1.5.7_linux_amd64.zip > terraform_data.zip

            # Remove zip local file reference in header (safe)
            dd if=terraform_data.zip of=terraform skip=1 bs=1 status=none
            sudo apt install unzip -y
            unzip terraform_1.5.7_linux_amd64.zip
            

            # Make binary executable
            chmod +x terraform

            # Move to PATH
            mv terraform /usr/local/bin/ || true

            # Check terraform works
            terraform version

            # Create terraform directory (if not exists)
            mkdir -p terraform
            cd terraform

            terraform init
            terraform apply -var="credentials_file=$GCP_KEY" -auto-approve
        '''
    }
}





    }
}
