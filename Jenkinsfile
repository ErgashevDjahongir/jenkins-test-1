pipeline {
    agent any

    triggers {
        pollSCM('H/1 * * * *')  // har 1 daqiqada tekshiradi
    }

    environment {
        IMAGE_NAME = "jenkins-nginx-test"
        CONTAINER_NAME = "jenkins-nginx-container"
    }

    stages {

        stage('Clone repository') {
            steps {
                echo "📥 GitHub'dan kod yuklanmoqda..."
                git branch: 'main', url: 'https://github.com/ErgashevDjahongir/jenkins-test-1.git'
            }
        }

        stage('Test') {
            steps {
                echo "🧪 Test bosqichi bajarilmoqda..."
                sh '''
                if [ -f "yangi.html" ]; then
                    echo "✅ Test o'tdi: yangi.html topildi!"
                else
                    echo "❌ Xato: yangi.html topilmadi!"
                    exit 1
                fi
                '''
            }
        }

        stage('Build Docker image') {
            steps {
                echo "🏗️ Docker image build qilinmoqda..."
                sh '''
                docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Deploy to container') {
            steps {
                echo "🚀 Docker konteyner ishga tushirilmoqda..."

                sh '''
                # Eski konteynerni to'xtatamiz
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true

                # Yangi konteynerni ishga tushuramiz
                docker run -d --name $CONTAINER_NAME  $IMAGE_NAME

                '''
            }
        }
    }
}
