pipeline {
  agent any

  environment {
    IMAGE_NAME = "simple-html-app"
    IMAGE_TAG  = "latest"
    FULL_IMAGE = "${env.IMAGE_NAME}:${env.IMAGE_TAG}"
    CONTAINER_NAME = "simple-html-container"
  }

  options {
    // Agar kerak bo'lsa: timeout va build log rotation qo'shing
    timeout(time: 30, unit: 'MINUTES')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // Agar Jenkins agent-da Docker mavjud bo'lsa, to'g'ridan-to'g'ri build
          sh "docker build -t ${FULL_IMAGE} ."
        }
      }
    }

    stage('Run Container') {
      steps {
        script {
          // Oldingi konteyner bo'lsa o'chirish
          sh """
            if [ \$(docker ps -a -q -f name=${CONTAINER_NAME} | wc -l) -gt 0 ]; then
              docker rm -f ${CONTAINER_NAME} || true
            fi
            docker run -d --name ${CONTAINER_NAME} -p 8080:80 ${FULL_IMAGE}
          """
        }
      }
    }

    stage('Smoke Test') {
      steps {
        script {
          // 8080 portidan sahifani tekshiramiz
          sh '''
            # Maks 10 bor kutib tekshirish (har 1s)
            i=0
            ok=0
            while [ $i -lt 10 ]; do
              sleep 1
              if curl -sS http://localhost:8080 | grep -i "Salom, Jahongir" >/dev/null 2>&1; then
                ok=1
                break
              fi
              i=$((i+1))
            done

            if [ "$ok" -ne 1 ]; then
              echo "App did not respond correctly"
              docker logs ${CONTAINER_NAME} || true
              exit 1
            fi

            echo "Smoke test passed"
          '''
        }
      }
    }

    stage('Cleanup') {
      steps {
        script {
          // Containerni o'chirish (istalsa saqlab ham qo'yish mumkin)
          sh "docker rm -f ${CONTAINER_NAME} || true"
          // Agar kerak bo'lsa image olib tashlash:
          sh "docker rmi -f ${FULL_IMAGE} || true"
        }
      }
    }
  }

  post {
    always {
      // Har doim konteynerni tozalaymiz
      sh "docker rm -f ${CONTAINER_NAME} || true"
    }
    success {
      echo "Pipeline muvaffaqiyatli tugadi ✅"
    }
    failure {
      echo "Pipeline xato bilan tugadi ❌"
    }
  }
}
