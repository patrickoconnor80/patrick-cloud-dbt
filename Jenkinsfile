node {

    stage('Clone Repository') {
        checkout scm
    }

    environment {
        IMAGE_TAG = sh(script: 'uuidgen | cut -c 1-10', returnStdout: true).trim()
    }

    stage('Build Image') {
        sh 'echo $AWS_REGION; echo $AWS_ACCOUNT_NUM'
        sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        sh "docker build -t patrick-cloud-$ENV-dbt-docs ."
        env.IMAGE_TAG = sh (script: 'uuidgen | cut -c 1-8', returnStdout: true).trim()
        sh "echo $IMAGE_TAG"
        sh "docker tag patrick-cloud-$ENV-dbt-docs:latest ${AWS_ACCOUNT_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com/patrick-cloud-$ENV-dbt-docs:latest"
        sh "docker tag patrick-cloud-$ENV-dbt-docs:latest ${AWS_ACCOUNT_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com/patrick-cloud-$ENV-dbt-docs:$IMAGE_TAG"
    }

    stage('Trivy Check Image') {
        sh "trivy --exit-code 0 --severity HIGH image patrick-cloud-$ENV-dbt-docs:latest"
        sh "trivy --exit-code 1 --severity CRITICAL image patrick-cloud-$ENV-dbt-docs:latest"
    }

    stage('Push Image') {
        sh "docker push ${AWS_ACCOUNT_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com/patrick-cloud-$ENV-dbt-docs:latest"
        sh "docker push ${AWS_ACCOUNT_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com/patrick-cloud-$ENV-dbt-docs:$IMAGE_TAG"
    }
    
    stage('Trigger DBT Docs Manifest Update') {
                echo "triggering dbt-docs-update-manifest"
                build job: 'dbt-docs-update-manifest', parameters: [string(name: 'DOCKERTAG', value: env.IMAGE_TAG)]
        }
}