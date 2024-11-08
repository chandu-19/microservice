
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-microservice"
        BLUE_CONTAINER = "my-microservice-blue"
        GREEN_CONTAINER = "my-microservice-green"
        PORT = "3000"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/my-microservice.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Blue-Green Deployment') {
            steps {
                script {
                    // Check if Blue is running
                    def blueRunning = sh(script: "docker ps -q -f name=${BLUE_CONTAINER}", returnStatus: true) == 0

                    if (blueRunning) {
                        // Blue is running, deploy to Green
                        echo 'Deploying to Green...'
                        sh """
                            docker stop ${GREEN_CONTAINER} || true
                            docker rm ${GREEN_CONTAINER} || true
                            docker run -d -p ${PORT}:${PORT} --name ${GREEN_CONTAINER} ${DOCKER_IMAGE}:latest
                        """
                    } else {
                        // Green is running, deploy to Blue
                        echo 'Deploying to Blue...'
                        sh """
                            docker stop ${BLUE_CONTAINER} || true
                            docker rm ${BLUE_CONTAINER} || true
                            docker run -d -p ${PORT}:${PORT} --name ${BLUE_CONTAINER} ${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
