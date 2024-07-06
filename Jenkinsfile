pipeline{
    agent any
    stages{
        stage("TF Init"){
            steps{
                echo "Executing Terraform Init"
                sh 'terraform init'
            }
        }
        stage("TF Validate"){
            steps{
                echo "Validating Terraform Code"
                sh 'terraform validate'
            }
        }
        stage("TF Plan"){
            steps{
                echo "Executing Terraform Plan"
                sh 'terraform plan'
            }
        }
        stage("TF Apply"){
            steps{
                echo "Executing Terraform Apply"
                sh 'python3 -m pip install --upgrade pip'
                sh 'python3 -m pip install requests'
                //sh 'terraform state rm aws_lambda_function.lambda'
                sh 'terraform apply -auto-approve'
            }
        }       
         stage('Invoke Lambda') {
            steps {
                 script {
                    def payload = '''
                        {
                            "subnet_id": "subnet-0009622cf3792440a",
                            "name": "Aryan Vijayvargiya",
                            "email": "aryanvijayvargiya16@gmail.com"
                        }
                    '''
                echo "Invoking Your Lambda Function"
                    def response = sh (
                        script: "aws lambda invoke --function-name DevOpsExamLambdaFunction --log-type Tail response.json",
                        returnStdout: true
                    )
                    
                    // Print Lambda response
                    echo "Lambda response: ${response}"
                    }
            }
        }
    }
}
