QUEUE_URL=$1
MESSAGE=$2
echo 'Sending message' $QUEUE_URL
aws \
  sqs send-message \
  --queue-url $QUEUE_URL \
  --message-body="HEY HEY" \
  --endpoint-url=http://localhost:4572

aws \
  sqs receive-message \
  --queue-url $QUEUE_URL \
  --endpoint-url=http://localhost:4572

{
  "QueueUrl": "https://sqs.us-east-1.amazonaws.com/851996801877/file-handler"
}

{
  "MD5OfMessageBody": "6c13bbc018990820de68838ae90b8d3a",
  "MessageId": "44d11b99-4e4f-45eb-8b2c-21cfa2f1ff05"
}
