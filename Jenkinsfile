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
        sh 'export IMAGETAG=$(docker images -q patrick-cloud-dev-dbt-docs --no-trunc | cut -d ":" -f 2)'
        sh 'echo $IMAGE_TAG'
        sh 'docker tag patrick-cloud-dev-dbt-docs:latest 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:latest'
    }

    stage('Trivy check image') {
        sh 'trivy --exit-code 0 --severity HIGH image patrick-cloud-dev-dbt-docs:latest'
        sh 'trivy --exit-code 1 --severity CRITICAL image patrick-cloud-dev-dbt-docs:latest'
    }

    stage('Push image') {
        sh 'docker push 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:latest'
    }
    
    stage('Trigger ManifestUpdate') {
                echo "triggering updatemanifestjob"
                build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
        }
}