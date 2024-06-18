pipeline{ 
    agent any

    environment {
      TOKEN = credentials('telegramToken')
      CHAT_ID = credentials('telegramChatId')
    }
    stages{ 
		    stage('Git Checkout') {
			      steps {
					      git branch: 'GEO-6-Setup-initial-Jenkins-pipelines', url: 'https://github.com/gazpacho-cloud/geocit-cloud-infrastructure'
				    }
			  }
    }
		post {
        always {
            cleanWs()
        }
        success {
            script{
                sh "curl --location --request POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' --form text='Build ${env.JOB_NAME} is successful: ${env.BUILD_URL}' --form chat_id='${CHAT_ID}'"
            }
        }
        failure {
            script{
                sh "curl --location --request POST 'https://api.telegram.org/bot${TOKEN}/sendMessage' --form text='Build ${env.JOB_NAME} failed: ${env.BUILD_URL}' --form chat_id='${CHAT_ID}'"
            }
        }
    }
}