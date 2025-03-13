pipeline {
    agent any
    
    environment {
        FLUTTER_HOME = '/usr/local/flutter' // Ruta donde está instalado Flutter en el servidor
        PATH = "$FLUTTER_HOME/bin:$PATH"
    }
    
    stages {
        stage('Checkout Código') {
            steps {
                git branch: 'main', url: 'https://github.com/Jhonaet10/soccer-cracks-app.git'
            }
        }
        
        stage('Instalar Dependencias') {
            steps {
                sh 'flutter pub get'
            }
        }
        
        stage('Compilar Aplicación') {
            steps {
                sh 'flutter build apk --debug'
            }
        }
        
        stage('Ejecutar Pruebas') {
            steps {
                sh 'flutter test'
            }
        }
        
        stage('Empaquetar y Archivar') {
            steps {
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-debug.apk', fingerprint: true
            }
        }
        
        stage('Despliegue') {
            steps {
                echo 'Desplegando la aplicación...'
                // Aquí puedes agregar comandos para subir el APK a Firebase App Distribution u otro servicio
            }
        }
    }
}

post{
  success{
    echo 'Build completed successfully!'
  }
  failure{
    echo 'Build completed failed!'
  }

}
