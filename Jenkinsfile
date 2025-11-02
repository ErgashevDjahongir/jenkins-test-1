pipeline {
  agent any

  environment {
    IMAGE = "simple-html-app:${env.BUILD_NUMBER}"
    CONTAINER_NAME = "simple-html-container-${env.BUILD_NUMBER}"
    HOST_PORT = "8080" // kerak bo'lsa o'zgartiring
    CONTAINER_PORT = "80"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker image') {
      steps {
        script {
          // Docker CLI mavjud deb hisoblaymiz (Jenkins agentda docker o'rnatilgan)
          sh "docker build -t ${IMAGE} ."
        }
      }
    }

    stage('Run container') {
      steps {
        script {
          // Agar eski container qolgan bo'lsa o'chirish
          sh """
            if docker ps -a --format '{{.Names}}' | grep -q ${CONTAINER_NAME}; then
              docker rm -f ${CONTAINER_NAME} || true
            fi
            docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${IMAGE}
          """
          // Kichik kutish: nginx ichida startup uchun bir necha soniya (odatda tez)
          sh "sleep 3"
        }
      }
    }

    stage('Smoke test') {
      steps {
        script {
          // container ichidagi sahifani tekshiramiz
          sh """
            echo "Sahifa HTTP status va bosh qatorni tekshirish:"
            HTTP_STATUS=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost:${HOST_PORT}/)
            echo "HTTP status: \$HTTP_STATUS"
            if [ "\$HTTP_STATUS" != "200" ]; then
              echo "Sahifa ochilmadi (status \$HTTP_STATUS)"
              docker logs ${CONTAINER_NAME} || true
              exit 1
            fi
            echo "Sahifa ochildi — muvaffaqiyat!"
          """
        }
      }
    }

    stage('Cleanup (optional)') {
      steps {
        script {
          // Agar container doimiy ishlashi kerak bo'lsa bu blokni o'chiring.
          // Hozir misolda containerni o'chirmaymiz — ammo agar xohlasangiz quyidagilarni ochiring:
          // sh "docker rm -f ${CONTAINER_NAME} || true"
          echo "Agar kerak bo'lsa containerni olib tashlashni bu yerda sozlang."
        }
      }
    }
  }

  post {
    failure {
      script { sh "docker logs ${CONTAINER_NAME} || true" }
    }
    always {
      echo "Build yakunlandi: ${env.BUILD_NUMBER}"
    }
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 841c03c6616eda3041ead4f2ba005f67e8505881
