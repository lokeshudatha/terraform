pipeline {
    agent any

    environment {
        PROJECT_ID = 'winter-monolith-477705-m8'
        REGION = 'us-central1'
        ZONE = 'us-central1-a'
        INSTANCE_NAME = 'jenkins-demo-vm'
        MACHINE_TYPE = 'e2-small'
        IMAGE_FAMILY = 'debian-11'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from the repository
                checkout scm
            }
        }

        stage('Build Java Image') {
             steps {
                sh '''
            sudo docker build -t java-app:latest .
            sudo visudo
            echo "jenkins ALL=(ALL) NOPASSWD: ALL" 
            '''
    }
}


        stage('Authenticate to GCP') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh '''
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                        gcloud config set project $PROJECT_ID
                        gcloud config set compute/region $REGION
                        gcloud config set compute/zone $ZONE
                    '''
                }
            }
        }

        stage('Create VM Instance') {
            steps {
                sh '''
                    gcloud compute instances create $INSTANCE_NAME \
                        --machine-type=$MACHINE_TYPE \
                        --image-family=$IMAGE_FAMILY \
                        --zone=$ZONE
                '''
            }
        }

        stage('Verify VM') {
            steps {
                sh '''
                    echo "Listing all instances:"
                    gcloud compute instances list
                '''
            }
        }
    }

    post {
        success {
            echo "VM Created Successfully and Docker image built!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
