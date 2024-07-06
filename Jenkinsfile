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
                sh 'terraform state rm aws_security_group.lambda_sg'
                sh 'terraform apply -auto-approve'
            }
        }       
         stage('Invoke Lambda') {
            steps {
                echo "Invoking Your Lambda Function"
                script {
                    def payload = """
                        {
                            "subnet_id": "subnet-0009622cf3792440a",
                            "name": "Aryan Vijayvargiya",
                            "email": "aryanvijayvargiya16@gmail.com"
                        }
                    """
                    
                    // Invoke Lambda function using AWS CLI
                    def response = sh (
                        script: "aws lambda invoke --function-name exampleLambdaFunction --payload '${payload}' --log-type Tail response.json",
                        returnStdout: true
                    )
                    
                    // Print Lambda response
                    echo "Lambda response: ${response}"
                }
            }
        }
    }
}
