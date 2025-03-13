pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/opt/flutter"  // Ruta de instalación de Flutter
        ANDROID_HOME = "/opt/android-sdk"
        PATH = "$FLUTTER_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-cred', url: 'https://github.com/Jhonaet10/soccer-cracks-app.git'
            }
        }

        stage('Setup Flutter') {
            steps {
                sh 'flutter doctor'
                sh 'flutter pub get'
            }
        }

        stage('Build APK') {
            steps {
                sh 'flutter build apk --release'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'flutter test'
            }
        }

        stage('Build iOS') {
            when {
                expression { return isUnix() } // Solo para macOS
            }
            steps {
                sh 'flutter build ios --no-codesign'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        sh 'fastlane android deploy' // Implementar Fastlane para Play Store
                        sh 'fastlane ios deploy' // Implementar Fastlane para App Store
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build y Deploy completados con éxito.'
        }
        failure {
            echo 'Falló el proceso de CI/CD.'
        }
    }
}
