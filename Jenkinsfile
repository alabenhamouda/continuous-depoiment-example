pipeline {
    agent any

    tools { 
        nodejs "node"
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
    }

    environment {
        ARM = credentials('b8989b85-3121-4662-bea6-7d41277deba9')
        ARM_ACCESS_KEY = credentials('37b62107-d4a3-430b-beaf-3cc32187d553')
    }

    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    sh 'npm install'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'npm run build'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh 'npm run test'
                }
            }
        }

        stage('Terraform Setup') {
            steps {
                script {
                    sh '''
                        export ARM_CLIENT_ID=${ARM_CLIENT_ID}
                        export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}
                        export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}
                        export ARM_TENANT_ID=${ARM_TENANT_ID}
                        terraform init -input=false -backend-config="access_key=$ARM_ACCESS_KEY"
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -input=false -auto-approve -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "subscription_id=$ARM_SUBSCRIPTION_ID" -var "tenant_id=$ARM_TENANT_ID"'
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    cleanWs()
                }
            }
        }
    }

    post {
        success {
            echo 'Build and tests passed'
        }
        failure {
            echo 'Build or tests failed. Take necessary actions.'
        }
    }
}
