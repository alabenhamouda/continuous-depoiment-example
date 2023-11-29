pipeline {
    agent any

    tools { 
        nodejs "node"
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
    }

    environment {
        AZURE = credentials('b8989b85-3121-4662-bea6-7d41277deba9')
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
                        export ARM_CLIENT_ID=${AZURE_CLIENT_ID}
                        export ARM_CLIENT_SECRET=${AZURE_CLIENT_SECRET}
                        export ARM_SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID}
                        export ARM_TENANT_ID=${AZURE_TENANT_ID}
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -input=false -auto-approve'
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
