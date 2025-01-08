aws ec2 describe-images --filters "Name=name,Values=debian*"

aws ec2 describe-vpcs

aws ec2 describe-security-groups

aws ec2 create-key-pair --key-name alex  --query "KeyMaterial" --output text > alex.pem



aws ec2 run-instances \
    --image-id ami-0fac08717e4b45cf4 \
    --count 1 \
    --instance-type t2.micro \
    --key-name alex \
    --security-group-ids sg-00674bef9b59e7c84 \
    --subnet-id subnet-06d69032d42e59087 \
    --associate-public-ip-address \
    --output table


aws ec2 describe-instances --instance-ids i-0a1bde7095a516b8a 
chmod 600 alex.pem
ssh -i alex.pem admin@3.235.129.186


aws ec2 stop-instances --instance-ids i-0a1bde7095a516b8a
aws ec2 delete-key-pair --key-name alex



