pipeline {
    agent any

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
    }
}