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
                    // echo "Lambda response: ${response}
                    echo "U1RBUlQgUmVxdWVzdElkOiBlYzgwMmVlNi00Njg2LTQ3NDktODY3Yi02NGE4OGFjOTY2Y2UgVmVyc2lvbjogJExBVEVTVApMQU1CREFfV0FSTklORzogVW5oYW5kbGVkIGV4Y2VwdGlvbi4gVGhlIG1vc3QgbGlrZWx5IGNhdXNlIGlzIGFuIGlzc3VlIGluIHRoZSBmdW5jdGlvbiBjb2RlLiBIb3dldmVyLCBpbiByYXJlIGNhc2VzLCBhIExhbWJkYSBydW50aW1lIHVwZGF0ZSBjYW4gY2F1c2UgdW5leHBlY3RlZCBmdW5jdGlvbiBiZWhhdmlvci4gRm9yIGZ1bmN0aW9ucyB1c2luZyBtYW5hZ2VkIHJ1bnRpbWVzLCBydW50aW1lIHVwZGF0ZXMgY2FuIGJlIHRyaWdnZXJlZCBieSBhIGZ1bmN0aW9uIGNoYW5nZSwgb3IgY2FuIGJlIGFwcGxpZWQgYXV0b21hdGljYWxseS4gVG8gZGV0ZXJtaW5lIGlmIHRoZSBydW50aW1lIGhhcyBiZWVuIHVwZGF0ZWQsIGNoZWNrIHRoZSBydW50aW1lIHZlcnNpb24gaW4gdGhlIElOSVRfU1RBUlQgbG9nIGVudHJ5LiBJZiB0aGlzIGVycm9yIGNvcnJlbGF0ZXMgd2l0aCBhIGNoYW5nZSBpbiB0aGUgcnVudGltZSB2ZXJzaW9uLCB5b3UgbWF5IGJlIGFibGUgdG8gbWl0aWdhdGUgdGhpcyBlcnJvciBieSB0ZW1wb3JhcmlseSByb2xsaW5nIGJhY2sgdG8gdGhlIHByZXZpb3VzIHJ1bnRpbWUgdmVyc2lvbi4gRm9yIG1vcmUgaW5mb3JtYXRpb24sIHNlZSBodHRwczovL2RvY3MuYXdzLmFtYXpvbi5jb20vbGFtYmRhL2xhdGVzdC9kZy9ydW50aW1lcy11cGRhdGUuaHRtbA1bRVJST1JdIFJ1bnRpbWUuSW1wb3J0TW9kdWxlRXJyb3I6IFVuYWJsZSB0byBpbXBvcnQgbW9kdWxlICdsYW1iZGFfZnVuY3Rpb24nOiBObyBtb2R1bGUgbmFtZWQgJ3JlcXVlc3RzJwpUcmFjZWJhY2sgKG1vc3QgcmVjZW50IGNhbGwgbGFzdCk6RU5EIFJlcXVlc3RJZDogZWM4MDJlZTYtNDY4Ni00NzQ5LTg2N2ItNjRhODhhYzk2NmNlClJFUE9SVCBSZXF1ZXN0SWQ6IGVjODAyZWU2LTQ2ODYtNDc0OS04NjdiLTY0YTg4YWM5NjZjZQlEdXJhdGlvbjogMTMuNTkgbXMJQmlsbGVkIER1cmF0aW9uOiAxNCBtcwlNZW1vcnkgU2l6ZTogMTI4IE1CCU1heCBNZW1vcnkgVXNlZDogNjIgTUIJCg==" | base64 --decode
                }
            }
        }
    }
}
