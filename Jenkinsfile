stage('Terraform Apply - Create VM') {
    steps {
        sh '''
            # Download standalone unzip (no sudo needed)
            wget https://github.com/kyz/libzip/releases/download/v1.8.0/unzip
            chmod +x unzip

            # Download and extract Terraform
            wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
            ./unzip terraform_1.5.7_linux_amd64.zip
            chmod +x terraform
            mv terraform /usr/local/bin/ || true

            # Enter terraform directory
            cd terraform

            terraform init

            terraform apply \
                -var="credentials_file=$GCP_KEY" \
                -auto-approve
        '''
    }
}
