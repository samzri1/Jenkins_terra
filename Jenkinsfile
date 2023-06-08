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
       
          sh 'terraform init'
        
      }
    }

    stage('Terraform Plan') {
      steps {
       
          sh 'terraform plan'
        
      }
    }

    stage('Terraform Appply') {
      steps {
        
          sh 'terraform apply -auto-approve'
        
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
