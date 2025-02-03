pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'python3 -m venv .venv'
                sh '''
                . .venv/bin/activate
                pip install -r requirements.txt
                cd .venv/lib/python3.12/site-packages/
                zip -rq ../../../../package.zip .
                cd ../../../../src
                zip -rq ../package.zip .
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''
                . .venv/bin/activate
                pip install pytest
                python -m pytest tests/
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                terraform init
                terraform apply -auto-approve
                '''
            }
        }
    }
    
    post {
        always {
            withCredentials([string(credentialsId: 'discord-webhook', variable: 'discord_webhook')]) {
                discordSend(
                    title: env.JOB_NAME,
                    link: env.BUILD_URL,
                    description: "${env.JOB_NAME} build result: ${currentBuild.currentResult}",
                    result: currentBuild.currentResult,
                    webhookURL: discord_webhook
                )
            }
        }
        cleanup {
            deleteDir()
        }
    }
}
