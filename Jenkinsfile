pipeline {
  agent any
    tools{
      maven 'M2_HOME'
          }
 
   stages {
    stage('Git checkout') {
      steps {
         echo 'This is for cloning the gitrepo'
         git branch: 'main', url: 'https://github.com/ashokstaragile/Banking-Demo.git'
                          }
            }
    stage('Create a Package') {
      steps {
         echo 'This will create a package using maven'
         sh 'mvn package'
                             }
            }

    stage('Publish the HTML Reports') {
      steps {
          publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/banking/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                        }
            }
    stage('Create a Docker image from the Package Insure-Me.jar file') {
      steps {
        sh 'docker build -t anshu9980/banking:1.0 .'
                    }
            }
    stage('Login to Dockerhub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerpass', usernameVariable: 'dockerlogin')]) {  
        sh 'docker login -u ${dockerlogin} -p ${dockerpass}'
                                                                    }
                                }
            }
    stage('Push the Docker image') {
      steps {
        sh 'docker push anshu9980/banking:1.0'
                                }
            }
    stage('Create Infrastructure using terraform') {
      steps {
            dir('scripts') {
            sh 'sudo chmod 600 learnawskey.pem'
            withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'jenkinsIAMuser', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh 'terraform init'
            sh 'terraform validate'
            sh 'terraform apply --auto-approve'
                      }
                 }
            }
        }

    }
}
