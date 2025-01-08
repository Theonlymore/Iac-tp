# install aws cli

sudo apt update

sudo apt install awscli -y

aws --version

aws configure -> ? todo

exemple :

AWS Access Key ID [None]: YOUR_ACCESS_KEY_ID
AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY
Default region name [None]: us-west-2
Default output format [None]: json

test if it work :

aws s3 ls
