pipeline{
  agent {label 'master'}
  stages{
    stage{
      steps{checkout scm}
    }
    stage('git clone'){
      steps{
        cleanWs()
        script{
          dir("${WORKSPACE}"){
            git branch: 'main', credentialsId: "${yourcredentials}", url: 'https://github.com/7-solutions/devops-assignment.git'
          }
        }
      }
    }
    stage('create Dockerfile'){
      steps{
        script{
          def dockerfilecontent = '''
          FROM golang:1.23rc1-alpine3.19
          WORKDIR /app
          COPY go.mod main.go ./

          RUN go mod download
          COPY . .

          RUN go build -o main .

          EXPOSE 8080
          CMD ["./main"]          
          '''
          writeFile file: 'Dockerfile', text: dockerfilecontent
        }
      }
    }
    stage('docker build'){
      steps{
        script{
          withCredentials([usernamePassword(credentialsId: "${yourdockercredential}",usernameVariable: 'USERNAME',passwordVariable: 'PASSWORD')])
          {
            dir("${WORKSPACE}"){
              sh"""
                sudo docker login {yourdockerregistry} -u ${USERNAME} -p ${PASSWORD}
                sudo docker build -t testgo:latest .
              """
            }
          }
        }
      }
    }
    stage('docker push'){
      steps{
        script{
          withCredentials([usernamePassword(credentialsId: "${yourdockercredential}",usernameVariable: 'USERNAME',passwordVariable: 'PASSWORD')])
          {
            dir("${WORKSPACE}"){
              sh"""
                sudo docker login {yourdockerregistry} -u ${USERNAME} -p ${PASSWORD}
                sudo docker tag testgo:latest chakorn/testgo:latest
                sudo docker push chakorn/testgo:latest
              """
            }
          }
        }
      }
    }
    stage('deploy'){
      steps{
        script{
          withCredentials([usernamePassword(credentialsId: "${yourdockercredential}",usernameVariable: 'USERNAME',passwordVariable: 'PASSWORD')])
          {
            dir("${WORKSPACE}"){
              sh"""
                sudo docker login {yourdockerregistry} -u ${USERNAME} -p ${PASSWORD}
                sudo docker pull chakorn/testgo:latest
                sudo docker run -d -p 8080:8080 chakorn/testgo:latest
              """
            }
          }
        }
      }
    }    
  }
}
