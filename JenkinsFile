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
        withCredentials([azureServicePrincipal('7349d3b2-951f-41be-877e-d8ccd9f3e73c')]) {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        withCredentials([azureServicePrincipal('7349d3b2-951f-41be-877e-d8ccd9f3e73c')]) {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform Appply') {
      steps {
        withCredentials([azureServicePrincipal('7349d3b2-951f-41be-877e-d8ccd9f3e73c')]) {
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
