node {

    stage('Clone repository') {
        checkout scm
    }

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
    
    stage('Trigger DBT Docs Manifest Update') {
                echo "triggering dbt-docs-update-manifest"
                build job: 'dbt-docs-update-manifest', parameters: [string(name: 'DOCKERTAG', value: env.IMAGE_TAG)]
        }
}