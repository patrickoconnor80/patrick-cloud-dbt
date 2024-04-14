node {
    def app

    stage('Clone repository') {

        checkout scm
    }

    // stage('Build image') {
  
    //    app = docker.build("dbt-docs")
    // }

    stage('Build image') {
            steps {
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 948065143262.dkr.ecr.us-east-1.amazonaws.com
                docker build -t patrick-cloud-dev-dbt-docs .
                docker tag patrick-cloud-dev-dbt-docs:latest 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:latest
                docker push 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:latest
            }
        }
    stage('Test image') {
  

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    // stage('Push image') {
        
    //     docker.withRegistry("https://${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com", 'dockerhub') {
    //         app.push("${env.BUILD_NUMBER}")
    //         app.push("latest")
    //     }
    // }
    
    stage('Trigger ManifestUpdate') {
                echo "triggering updatemanifestjob"
                build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
        }
}