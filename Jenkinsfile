pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/samzri1/Jenkins_terra.git'
      }
    }

    stage('Terraform Init') {
      steps {
        withCredentials([azureServicePrincipal('azure_env')]) {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        withCredentials([azureServicePrincipal('azure_env')]) {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform Appply') {
      steps {
        withCredentials([azureServicePrincipal('azure_env')]) {
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }

    success {
      echo 'Deployment completed successfully.'
    }

    failure {
      echo 'Deployment failed.'
    }
  }
}
