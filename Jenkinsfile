pipeline {
    agent any

    environment {
        CONTAINER_NAME = "cicd-prject-app"
        IMAGE_NAME = "cicd-prject"
        OLD_CONTAINER_NAME = "cicd-prject-backup"
    }

    stages {

        stage('Source Control Checkout') {
            steps {
                echo 'Pulling source code from GitHub...'
                checkout scm
            }
        }

        stage('Automated Testing') {
            steps {
                echo 'Running automated test...'
                sh '''
                if [ -f cicd-prject.html ]; then
                    echo "Test Passed: cicd-prject.html file exists."
                else
                    echo "Test Failed: cicd-prject.html file does not exist."
                    exit 1
                fi
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
                sh 'docker tag $IMAGE_NAME:$BUILD_NUMBER $IMAGE_NAME:latest'
            }
        }

        stage('Deployment') {
            steps {
                echo 'Deploying application container...'

                sh '''
                docker rm -f $OLD_CONTAINER_NAME || true
                docker rename $CONTAINER_NAME $OLD_CONTAINER_NAME || true
                docker run -d -p 8081:80 --name $CONTAINER_NAME $IMAGE_NAME:latest
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo 'Checking application health...'

                sh '''
                sleep 5

                if curl -f http://localhost:8081; then
                    echo "Deployment successful. Application is healthy."
                else
                    echo "Deployment failed. Starting rollback..."
                    docker rm -f $CONTAINER_NAME || true
                    docker rename $OLD_CONTAINER_NAME $CONTAINER_NAME || true
                    docker start $CONTAINER_NAME || true
                    exit 1
                fi
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
        }

        failure {
            echo 'CI/CD pipeline failed. Rollback executed if deployment failed.'
        }
    }
}