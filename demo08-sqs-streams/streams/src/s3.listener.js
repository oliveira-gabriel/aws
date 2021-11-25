class Handler {
  
  constructor({ s3Svc, sqsSvc }) {
    this.s3Svc = s3Svc;
    this.sqsSvc = sqsSvc;
    this.QueueName = process.env.SQS_QUEUE;
  }

  static getSdks() {
    const host = process.env.LOCALSTACK_HOST || "localhost";
    const port = process.env.LOCALSTACK_PORT || "4566";
    const isLocal = process.env.IS_LOCAL;
    const endpoint = new AWS.Endpoint(`http://${host}:${port}`);

    const config = {
      endpoint: endpoint,
      s3ForcePathStyle: true,
    };
    if (!isLocal) delete config.endpoint;
    console.log(config);
    return {
      s3: new AWS.S3(config),
      sqs: new AWS.SQS(config),
    };
  }

  async GetQueueUrl() {
    const { QueueUrl } = await this.sqsSvc
      .getQueueUrl({
        QueueName: this.QueueName,
      })
      .promise();
    return QueueUrl;
  }

  async main(event) {
    console.log("***event", JSON.stringify(event, null, 2));
    try {
      return {
        statusCode: 200,
        body: "Hello",
      };
    } catch (error) {
      console.log("***error", error.stack);
      return {
        statusCode: 500,
        body: "Internal Error",
      };
    }
  }
}
const { s3, sqs } = Handler.getSdks();
const handler = new Handler({ s3Svc: s3, sqsSvc: sqs });
module.exports = handler.main.bind(handler);
