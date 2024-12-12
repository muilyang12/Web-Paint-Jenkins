pipeline {
    agent any

    environment {
        AWS_REGION = "${env.AWS_REGION}"
        AWS_ACCOUNT_ID = "${env.AWS_ACCOUNT_ID}"
    }

    stages {
        stage("Checkout") {
            steps {
                git url: "https://github.com/muilyang12/Web-Paint.git", branch: "main"
            }
        }

        stage("Set Gradle Wrapper Permissions") {
            steps {
                dir("webpaint-be") {
                    sh "chmod +x gradlew"
                }
            }
        }

        stage("Build") {
            steps {
                dir("webpaint-be") {
                    sh "./gradlew clean build"
                }
            }
        }

        stage("Docker Build") {
            steps {
                dir("webpaint-be") {
                    sh "docker build -t webpaint-be:${BUILD_NUMBER} ."
                }
            }
        }

        stage("Deploy") {
            steps {
                sh """
                    docker stop webpaint-be || true
                    docker rm webpaint-be || true
                    docker run -d -p 8080:8080 --name webpaint-be webpaint-be:${BUILD_NUMBER}
                """
            }
        }

        stage("Login to ECR") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'UTDEmailRootAccountCredential']]) {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS \
                        --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    """
                }
            }
        }

        stage("Push to ECR") {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'UTDEmailRootAccountCredential']]) {
                    sh """
                        docker tag webpaint-be:${BUILD_NUMBER} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/webpaint-be:${BUILD_NUMBER}
                        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/webpaint-be:${BUILD_NUMBER}
                    """
                }
            }
        }
    }
}