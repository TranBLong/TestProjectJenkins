pipeline {
    agent any
    environment {
        IMAGE_NAME = "myblazorapp"
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "docker build -t $DOCKER_USER/$IMAGE_NAME:latest ."
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push $DOCKER_USER/$IMAGE_NAME:latest"
                }
            }
        }
        stage('Deploy on Server') {
            steps {
                sh "docker compose -f docker-compose.prod.yml up -d --build"
            }
        }
    }
}