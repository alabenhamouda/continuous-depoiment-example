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
                        terraform init -input=false -backend-config="access_key=$ARM_ACCESS_KEY" -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "subscription_id=$ARM_SUBSCRIPTION_ID" -var "tenant_id=$ARM_TENANT_ID"
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

        stage('Docker Build') {
            steps {
                script {
                    sh 'docker build -t alabenhmouda/cd-example .'
                }
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'cfcabbf3-82d8-40f5-9311-983452136145', usernameVariable: 'DOCKERUSER', passwordVariable: 'DOCKERPASS')]) {
                    sh 'docker login -u $DOCKERUSER -p $DOCKERPASS'
                    sh 'docker push alabenhmouda/cd-example'
                }
            }
        }

        stage('Azure Deploy') {
            steps {
                script {
                    sh 'az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID'
                    sh 'az webapp create --resource-group cd-test-rg --plan cd-app-service-plan --name cd-app-service --deployment-container-image-name alabenhmouda/cd-example'
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
