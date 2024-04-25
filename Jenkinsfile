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

    stage('Update Image Tag in Manifest') {
        script {
            withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                sh """
                    git config user.email patrickoconnor8014@gmail.com
                    git config user.name patrickoconnor80
                    cat cfg/dbt.yaml
                    sed -i 's+${AWS_ACCOUNT_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com/patrick-cloud-$ENV-dbt-docs.*+${AWS_ACCOUNT_NUM}.dkr.ecr.${AWS_REGION}.amazonaws.com/patrick-cloud-$ENV-dbt-docs:${IMAGE_TAG}+g' cfg/dbt.yaml
                    cat cfg/dbt.yaml
                    git add .
                    git commit -m 'Done by Jenkins Job changemanifest: ${env.BUILD_NUMBER}'
                    git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/patrick-cloud-kubernetes.git HEAD:main
                """
            }
        }
    }

}