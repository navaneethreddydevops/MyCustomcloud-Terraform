# MyCustomcloud-Terraform
My Terraform Templates to Build the web-servers with High Availablity

This will have ansible roles to deploy the code packages

Jenkins file with Multi stage Builds

##### To get the Latest AMI:

aws ec2 describe-images \
     --owners aws-marketplace \
     --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce \
     --query 'Images[*].[CreationDate,Name,ImageId]' \
    --filters "Name=name,Values=CentOS Linux 7*" \
    --region us-west-2 \
    --output table \
    | sort -r