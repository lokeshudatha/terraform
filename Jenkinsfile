pipeline {
    agent any

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
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh """
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud config set project winter-monolith-477705-m8
                    """
                }
            }
        }
        stage('single VM') {
            steps {
                sh '''
                    gcloud compute instances create multi-vm --zone=us-central1-a --machine-type=e2-small --image-family=debian-11 --image-project=debian-cloud
                    sudo apt-get update
                    sudo apt-get install \
                    apt-transport-https \
                    ca-certificates \
                    curl \
                    gnupg \
                    lsb-release -y
                    sudo mkdir -p /etc/apt/keyrings
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                    echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                    sudo apt-get update
                    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
                    sudo apt-mark hold docker-ce
                    sudo usermod -aG docker username
                    sudo docker version
                    rm /etc/containerd/config.toml
                    systemctl restart containerd
                    ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P 
                    ssh-copy-id -i ~/.ssh/id_rsa.pub  lokesh@35.239.117.1
                '''
            }
        }
        stage('build python image') {
            steps {
                sh '''
                    docker build -t python_image:latest .
                '''
            }
        }
        stage ('push python image') {
            environment {
                DOCKERHUB_CREDENTIALS = credentials('docker-cred')
            }   
            steps {
                sh '''
                    docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
                    docker tag python_image:latest 9515524259/python_image:latest
                    docker push 9515524259/python_image:latest
                '''
            }
        }

    }
} 


