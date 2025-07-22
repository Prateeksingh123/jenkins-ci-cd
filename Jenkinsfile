pipeline {
    agent any

    tools {
        maven "maven" // This should match the Maven name in Jenkins > Global Tool Configuration
    }

    stages {
        stage('SCM checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/Prateeksingh123/jenkins-ci-cd.git']]
                )
            }
        }

        stage('Build') {
            steps {
                script {
                    bat 'mvn clean install'
                }
            }
        }
        stage('Deploy to Container') {
            steps {
                deploy adapters: [
                    tomcat9(alternativeDeploymentContext: '',
                    credentialsId: 'tomcat-pwd',
                    path: '',
                    url: 'http://localhost:9090/')],
                    contextPath: 'jenkinsCiCd',
                    war: '**/*.war'
            }
        }
    }
    post {
        always {
            emailext(
                attachLog: true,
                subject: "📦 Build Result: ${currentBuild.currentResult} - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                mimeType: 'text/html',
                body: """
                    <html>
                    <body>
                        <p>Hi Team,</p>

                        <p>The build <b>#${env.BUILD_NUMBER}</b> of <b>${env.JOB_NAME}</b> has completed with status:
                        <span style="color:${currentBuild.currentResult == 'SUCCESS' ? 'green' : 'red'};">
                            <b>${currentBuild.currentResult}</b>
                        </span>.</p>

                        <ul>
                            <li><b>Job:</b> ${env.JOB_NAME}</li>
                            <li><b>Build Number:</b> ${env.BUILD_NUMBER}</li>
                            <li><b>Build URL:</b> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></li>
                            <li><b>Duration:</b> ${currentBuild.durationString}</li>
                        </ul>

                        <p>Best regards,<br>Jenkins</p>
                    </body>
                    </html>
                """,
                to: 'prateeksingh825@gmail.com'
            )
        }
    }
}