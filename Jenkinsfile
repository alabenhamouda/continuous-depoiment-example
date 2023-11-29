pipeline {
    agent any

    tools { 
        nodejs "node"
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
    }

    environment {
        ARM = credentials('b8989b85-3121-4662-bea6-7d41277deba9')
    }

    stages {
        // stage('Install Dependencies') {
        //     steps {
        //         ansiColor('xterm') {
        //             sh 'npm install'
        //         }
        //     }
        // }

        // stage('Build') {
        //     steps {
        //         ansiColor('xterm') {
        //             sh 'npm run build'
        //         }
        //     }
        // }

        // stage('Run Tests') {
        //     steps {
        //         ansiColor('xterm') {
        //             sh 'npm run test'
        //         }
        //     }
        // }

        stage('Terraform Setup') {
            steps {
                ansiColor('xterm') {
                    sh '''
                        export ARM_CLIENT_ID=${ARM_CLIENT_ID}
                        export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}
                        export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}
                        export ARM_TENANT_ID=${ARM_TENANT_ID}
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                ansiColor('xterm') {
                    sh 'terraform apply -input=false -auto-approve -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "subscription_id=$ARM_SUBSCRIPTION_ID" -var "tenant_id=$ARM_TENANT_ID'
                }
            }
        }

        stage('Cleanup') {
            steps {
                ansiColor('xterm') {
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
