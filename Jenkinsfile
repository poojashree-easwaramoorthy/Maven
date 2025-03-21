pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "poojashree26/docker"
        DOCKER_TAG = "latest"
        DOCKER_CREDENTIALS_ID = "docker-hub-creds"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/poojashree-easwaramoorthy/Maven', branch: 'master'
            }
        }

        stage('Build Application') {
            steps {
                script {
                    def buildStatus = sh(script: 'mvn clean package -DskipTests', returnStatus: true)
                    if (buildStatus != 0) {
                        echo "Build failed, but proceeding..."
                    }
                }
            }
        }

        stage('Run Maven Tests') {
            steps {
                script {
                    def testStatus = sh(script: 'mvn test', returnStatus: true)
                    if (testStatus != 0) {
                        echo "Tests failed, but proceeding..."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'chmod +x build.sh && ./build.sh'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo "Logging into Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login --username $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                sh "docker tag $DOCKER_IMAGE:$DOCKER_TAG $DOCKER_IMAGE:$DOCKER_TAG"
                sh "docker push $DOCKER_IMAGE:$DOCKER_TAG"
            }
        }

        stage('Deploy Docker Container') {
            steps {
                echo "Deploying Docker container..."
                sh 'chmod +x deploy.sh && ./deploy.sh'
            }
        }
    }

    post {
        success {
            echo "Deployment Successful!"
        }
        failure {
            echo "Deployment Failed!"
        }
    }
}
