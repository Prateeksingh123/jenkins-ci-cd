pipeline {
    agent any

    tools {
        maven "maven" // This should match the Maven name in Jenkins > Global Tool Configuration
    }

    environment {
        APP_NAME = 'spring-docker-cicd'
        RELEASE_NO = '1.0.0'
        DOCKER_USER = 'prateeksingh825'
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE_NO}-${BUILD_NUMBER}"
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
        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker build -t %IMAGE_NAME%:%IMAGE_TAG% .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        bat '''
                            docker login -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%
                            docker push %IMAGE_NAME%:%IMAGE_TAG%
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            emailext(
                attachLog: true,
                subject: "Build Result: ${currentBuild.currentResult} - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
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