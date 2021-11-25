CLUSTER_NAME=serverless
USERNAME=root
PASSWORD=123456Ww
DB_NAME=heroes
SECRET_NAME=aurora-secret01

RESOURCE_ARN=arn:aws:rds:us-east-1:583704929827:cluster:serverless

SECRET_ARN=arn:aws:secretsmanager:us-east-1:583704929827:secret:aurora-secret01-cr7mHk

aws rds create-db-cluster \
  --engine-version 5.6.10a \
  --db-cluster-identifier $CLUSTER_NAME \
  --engine-mode serverless \
  --engine aurora \
  --master-username $USERNAME \
  --master-user-password $PASSWORD \
  --scaling-configuration MinCapacity=2,MaxCapacity=4,TimeoutAction=ForceApplyCapacityChange \
  --enable-http-endpoint \
  --region us-east-1 |
  tee rds-cluster.json

CREATING="creating"
STATUS=$CREATING

while [ $STATUS == $CREATING ]; do
  STATUS=$(aws rds describe-db-clusters \
    --db-cluster-identifier $CLUSTER_NAME \
    --query 'DBClusters[0].Status' |
    tee rds-status.txt)
  echo $STATUS
  sleep 1
done

aws secretsmanager create-secret \
  --name $SECRET_NAME \
  --description "Credentials for aurora serverless db" \
  --secret-string '{"username":"'$USERNAME'", "password":"'$PASSWORD'"}' \
  --region us-east-1 |
  tee secret.json

aws rds-data execute-statement \
  --resource-arn $RESOURCE_ARN \
  --secret-arn $SECRET_ARN \
  --database mysql \
  --sql "show databases;" \
  --region us-east-1 |
  tee cmd-show-dbs.json

aws rds-data execute-statement \
  --resource-arn $RESOURCE_ARN \
  --secret-arn $SECRET_ARN \
  --database mysql \
  --sql "CREATE DATABASE $DB_NAME;" \
  --region us-east-1 |
  tee cmd-create-db.json

aws rds describe-db-subnet-groups |
  tee db-subnets.json

aws rds delete-db-cluster \
  --db-cluster-identifier $CLUSTER_NAME \
  --skip-final-snapshot |
  tee rds-delete.cluster.json

aws secretsmanager delete-secret \
  --secret-id $SECRET_NAME |
  tee secret-delete.json
