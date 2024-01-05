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
                sh '''
                sudo apt-get update 
                sudo apt install apache2 -y
                sudo systemctl start apache2 
                sudo systemctl enable apache2
                git clone https://github.com/gabrielecirulli/2048.git
                cp -R 2048/* /var/www/html
                '''
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

