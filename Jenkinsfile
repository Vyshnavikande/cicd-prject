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

        stage('Install Dependencies') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }

        stage('Automated Testing') {
            steps {
                echo 'Running automated tests...'
                sh 'npm test'
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
                echo 'Deploying application...'

                sh '''
                if docker ps -a --format '{{.Names}}' | grep -w $OLD_CONTAINER_NAME; then
                    docker rm -f $OLD_CONTAINER_NAME
                fi

                if docker ps -a --format '{{.Names}}' | grep -w $CONTAINER_NAME; then
                    docker rename $CONTAINER_NAME $OLD_CONTAINER_NAME
                fi

                docker run -d -p 3000:3000 --name $CONTAINER_NAME $IMAGE_NAME:latest
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo 'Checking application health...'

                sh '''
                sleep 5

                if curl -f http://localhost:3000/health; then
                    echo "Deployment successful. Application is healthy."
                else
                    echo "Deployment failed. Starting rollback..."
                    docker rm -f $CONTAINER_NAME
                    docker rename $OLD_CONTAINER_NAME $CONTAINER_NAME
                    docker start $CONTAINER_NAME
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