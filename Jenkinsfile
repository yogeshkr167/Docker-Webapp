pipeline {
    agent any
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yogeshkr167/Devops_shell_scripts.git'
            }
        }

        stage('Docker Build Image') {
            steps {
                sh 'docker image build -t $JOB_NAME:v1.$BUILD_ID .'
                sh 'docker image tag $JOB_NAME:v1.$BUILD_ID yogeshkr167/$JOB_NAME:v1.$BUILD_ID'
                sh 'docker image tag $JOB_NAME:v1.$BUILD_ID yogeshkr167/$JOB_NAME:latest'
            }
        }

        stage('Pushing Image to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'DockerPasswd', variable: 'DockerPasswd')]) {
                    sh 'docker login -u yogeshkr167 -p $DockerPasswd'
                    sh 'docker push yogeshkr167/$JOB_NAME:latest'
                    sh 'docker push yogeshkr167/$JOB_NAME:v1.$BUILD_ID'
                    sh 'docker image rm $JOB_NAME:v1.$BUILD_ID yogeshkr167/$JOB_NAME:v1.$BUILD_ID yogeshkr167/$JOB_NAME:latest'
                }
            }
        }

        stage('Docker Container Deployment') {
            steps {
                script {
                    def docker_run = 'docker run -itd --name scriptedcontainer yogeshkr167/docker-groovy-webapp'
                    def docker_rm_container = 'docker rm -f scriptedcontainer'
                    def docker_rm_image = 'docker image rm -f yogeshkr167/docker-groovy-webapp'

                    sshagent(['web_app_server']) {
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.27.198 ${docker_rm_container} || true"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.27.198 ${docker_rm_image} || true"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.27.198 ${docker_run}"
                    }
                }
            }
        }
    }
}
