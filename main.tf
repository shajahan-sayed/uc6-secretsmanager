#creating secret manager

resource "aws_secretsmanager_secret" "my_secret" {
   name = "my_secret"
   description = "database credentials"

   tags = {
     Enviorment = "prod"
   }
 }

 #creating secret version to store actual value

 resource "aws_secretsmanager_secret_version" "my_secret_value" {
    secret_id = aws_secretmanager_secret.my_secret.id
    secret_string = jsonencode9({
    username = "dbuser"
    password = "SuperSecret123!"
  })
}

#creating IAM permission so ec2 or lambda can read secrets

resource "aws_iam_policy" "secret_policy" {
   name = "secret_policy"
   description = "ec2 read secrets from secret manager"
   policy      = jsonencode({
   Version = "2012-10-17",
   Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = aws_secretsmanager_secret.my_secret.arn
      }
    ]
  })
}
