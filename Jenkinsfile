node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        docker.withServer('unix:///var/run/docker.sock', '') {
          app = docker.build('backend')
          app.tag("${env.BUILD_NUMBER}")
        }
    }

    stage('Run http test') {
        docker.withServer('unix:///var/run/docker.sock', '') {
            docker.image("backend:${env.BUILD_NUMBER}").withRun('-p 6000:3000') {c ->
                sleep 3
                sh "curl http://${env.HOST_IP}:6000 &> /dev/null"
            }
         }
    }

  stage('Push image') {
        docker.withRegistry("https://${env.HOST_IP}:5000", '') {
            app.push("${env.BUILD_NUMBER}")
        }
    }

  stage('Deploy To Swarm') {
      // Check if service runs, then perform rolling upgrade, else deploy.
      if (sh(returnStatus: true, script: "docker service inspect backend") == 0) {
          echo "Performing rolling upgrade of service."
          sh "docker service update --image ${env.HOST_IP}:5000/backend:${env.BUILD_NUMBER} backend"
      } else {
          echo "Performing deploy of service."
          sh "docker service create --replicas 2 -e HOST_IP=${env.HOST_IP} -p 6000:3000 --name backend ${env.HOST_IP}:5000/backend:${env.BUILD_NUMBER}"
      }
  }

  stage('Verify Deployment') {
    sh "curl http://${env.HOST_IP}:6000 &> /dev/null"
  }

}
