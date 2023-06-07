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
        withCredentials([azureServicePrincipal('393e3de3-0900-4b72-8f1b-fb3b1d6b97f1')]) {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        withCredentials([azureServicePrincipal('393e3de3-0900-4b72-8f1b-fb3b1d6b97f1')]) {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform Appply') {
      steps {
        withCredentials([azureServicePrincipal('393e3de3-0900-4b72-8f1b-fb3b1d6b97f1')]) {
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
