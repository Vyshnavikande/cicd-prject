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