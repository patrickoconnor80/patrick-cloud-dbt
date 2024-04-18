node {

    stage('Clone Repository') {
        checkout scm
    }

    environment {
        IMAGE_TAG = sh(script: 'uuidgen | cut -c 1-10', returnStdout: true).trim()
    }

    stage('Build Image') {
        sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 948065143262.dkr.ecr.us-east-1.amazonaws.com'
        sh 'docker build -t patrick-cloud-dev-dbt-docs .'
        env.IMAGE_TAG = sh (script: 'uuidgen | cut -c 1-8', returnStdout: true).trim()
        sh "echo $IMAGE_TAG"
        sh 'docker tag patrick-cloud-dev-dbt-docs:latest 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:latest'
        sh "docker tag patrick-cloud-dev-dbt-docs:latest 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:$IMAGE_TAG"
    }

    stage('Trivy Check Image') {
        sh 'trivy --exit-code 0 --severity HIGH image patrick-cloud-dev-dbt-docs:latest'
        sh 'trivy --exit-code 1 --severity CRITICAL image patrick-cloud-dev-dbt-docs:latest'
    }

    stage('Push Image') {
        sh 'docker push 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:latest'
        sh "docker push 948065143262.dkr.ecr.us-east-1.amazonaws.com/patrick-cloud-dev-dbt-docs:$IMAGE_TAG"
    }
    
    stage('Trigger DBT Docs Manifest Update') {
                echo "triggering dbt-docs-update-manifest"
                build job: 'dbt-docs-update-manifest', parameters: [string(name: 'DOCKERTAG', value: env.IMAGE_TAG)]
        }
}