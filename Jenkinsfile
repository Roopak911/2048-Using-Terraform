pipeline {
    agent any
    triggers {
    githubPush()
    }    
    stages {
        stage('Git-checkout') {
            steps {
               
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Roopak911/2048-Using-Terraform.git']])
            }
        }

        stage('Install game files') {
            steps {
                sh 'bash game.sh'
             }
        }
        stage('run terraform') {
            steps {
                sh '''
		sudo cd /var/lib/jenkins/workspace/2048-game/
		terraform init
                terraform plan
                terraform apply --auto-approve
                '''
            }
        }
    }
}

