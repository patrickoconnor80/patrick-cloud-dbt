node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    // stage('Build image') {
  
    //    app = docker.build("dbt-docs")
    // }

    stage('Build image') {
        sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 948065143262.dkr.ecr.us-east-1.amazonaws.com'
        sh 'docker build -t patrick-cloud-dev-dbt-docs .'
        sh 'docker tag patrick-cloud-dev-dbt-docs:latest 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:latest'
    }

    stage('Trivy check image') {
        sh 'trivy image patrick-cloud-dev-dbt-docs:latest > trivyimage.txt'
        sh 'trivy --exit-code 0 --severity HIGH image patrick-cloud-dev-dbt-docs:latest'
        sh 'trivy --exit-code 1 --severity CRITICAL image patrick-cloud-dev-dbt-docs:latest'
    }

    stage('Push image') {
        sh 'docker push 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:latest'
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