//The pipeline should retrieve the code,
//build the respective images, and deploy each application to separate
//Terraform-provisioned VMs - Python on one VM and Java on the other.

pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from the repository
                Checkout scm
            }
        }
        stage('Build Docker Images') {
            parallel {
                stage('Build Python Image') {
                    steps {
                            sh 'docker build -t python-app:latest .'   
                        }
                    }
                }
                stage('Build Java Image') {
                    steps {                        
                            sh 'docker build -t java-app:latest .'                            
                        }
                    }
                }
            }
        }
