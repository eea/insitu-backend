pipeline {
  agent any

  environment {
    IMAGE_NAME = "eeacms/insitu-backend"
    GIT_NAME = "insitu-backend"
    SONARQUBE_TAG = 'insitu.copernicus.eu'
    RANCHER_STACKID = ""
    RANCHER_ENVID = ""
    template = "templates/insitu-backend"
  }

  parameters {
    string(defaultValue: '', description: 'Run tests with GIT_BRANCH env enabled', name: 'TARGET_BRANCH')
  }
  
  stages {
    stage('Build & Test') {
      environment {
        TAG = BUILD_TAG.toLowerCase()
      }
      steps {
        node(label: 'docker') {
          script {
            try {
              checkout scm
              sh '''docker build -t ${IMAGE_NAME}:${TAG} .'''
              sh '''./test/run.sh ${IMAGE_NAME}:${TAG}'''
            } finally {
              sh script: "docker rmi ${IMAGE_NAME}:${TAG}", returnStatus: true
            }
          }
        }
      }
    }
 
    stage('Release on tag creation') {
       when {
    buildingTag()
    not { expression { BUILD_TAG.toLowerCase().contains('beta') } }
    not { expression { BUILD_TAG.toLowerCase().contains('alpha') } }
  }
      steps{
        node(label: 'docker') {
          withCredentials([string(credentialsId: 'eea-jenkins-token', variable: 'GITHUB_TOKEN'),  string(credentialsId: 'insitu-backend-trigger', variable: 'TRIGGER_MAIN_URL'), usernamePassword(credentialsId: 'jekinsdockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
           sh '''docker pull eeacms/gitflow; docker run -i --rm --name="$BUILD_TAG"  -e GIT_BRANCH="$BRANCH_NAME" -e GIT_NAME="$GIT_NAME" -e DOCKERHUB_REPO="eeacms/insitu-backend" -e GIT_TOKEN="$GITHUB_TOKEN" -e DOCKERHUB_USER="$DOCKERHUB_USER" -e DOCKERHUB_PASS="$DOCKERHUB_PASS"  -e TRIGGER_MAIN_URL="$TRIGGER_MAIN_URL" -e DEPENDENT_DOCKERFILE_URL="" -e GITFLOW_BEHAVIOR="RUN_ON_TAG" eeacms/gitflow'''
         }

        }
      }
    }


    stage('Upgrade demo ( on tag )') {
      when {
        buildingTag()
      }
      steps {
        node(label: 'docker') {
          withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'Rancher_dev_token', usernameVariable: 'RANCHER_ACCESS', passwordVariable: 'RANCHER_SECRET'],string(credentialsId: 'Rancher_dev_url', variable: 'RANCHER_URL')]) {
            sh '''wget -O rancher_upgrade.sh https://raw.githubusercontent.com/eea/eea.docker.gitflow/master/src/rancher_upgrade.sh'''
            sh '''chmod 755 rancher_upgrade.sh'''
            sh '''./rancher_upgrade.sh'''
         }
        }
      }
    }
    

    stage('Update SonarQube Tags: Prod') {
      when {
        not {
          environment name: 'SONARQUBE_TAG', value: ''
        }
        buildingTag()
      }
      steps{
        node(label: 'docker') {
          withSonarQubeEnv('Sonarqube') {
            withCredentials([string(credentialsId: 'eea-jenkins-token', variable: 'GIT_TOKEN')]) {
              sh '''docker pull eeacms/gitflow'''
              sh '''docker run -i --rm --name="${BUILD_TAG}-sonar" -e GIT_NAME=${GIT_NAME} -e GIT_TOKEN="${GIT_TOKEN}" -e SONARQUBE_TAG=${SONARQUBE_TAG} -e SONARQUBE_TOKEN=${SONAR_AUTH_TOKEN} -e SONAR_HOST_URL=${SONAR_HOST_URL}  eeacms/gitflow /update_sonarqube_tags_backend.sh'''
            }
          }
        }
      }
    }

    stage('Update SonarQube Tags: Demo') {
      when {
        not {
          environment name: 'SONARQUBE_TAG_DEMO', value: ''
        }
        buildingTag()
      }
      steps{
        node(label: 'docker') {
          withSonarQubeEnv('Sonarqube') {
            withCredentials([string(credentialsId: 'eea-jenkins-token', variable: 'GIT_TOKEN')]) {
              sh '''docker pull eeacms/gitflow'''
              sh '''docker run -i --rm --name="${BUILD_TAG}-sonar" -e GIT_NAME=${GIT_NAME} -e GIT_TOKEN="${GIT_TOKEN}" -e SONARQUBE_TAG=${SONARQUBE_TAG_DEMO} -e SONARQUBE_TOKEN=${SONAR_AUTH_TOKEN} -e SONAR_HOST_URL=${SONAR_HOST_URL}  eeacms/gitflow /update_sonarqube_tags_backend.sh'''
            }
          }
        }
      }
    }
 }

  post { 
    always {
      cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true)
    }
    changed {
      script {
        def details = """<h1>${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - ${currentBuild.currentResult}</h1>
                         <p>Check console output at <a href="${env.BUILD_URL}/display/redirect">${env.JOB_BASE_NAME} - #${env.BUILD_NUMBER}</a></p>
                      """
        emailext(
        subject: '$DEFAULT_SUBJECT',
        body: details,
        attachLog: true,
        compressLog: true,
        recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'CulpritsRecipientProvider']]
        )
      }
    }
  }

}
