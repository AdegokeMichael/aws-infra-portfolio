const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
    console.log("Received event:", JSON.stringify(event, null, 2));

    const bucket = event.Records[0].s3.bucket.name;
    const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    const timestamp = new Date().toISOString();

    const params = {
        TableName: process.env.DYNAMODB_TABLE,
        Item: {
            id: `${bucket}/${key}`,
            uploaded_at: timestamp
        }
    };

    await dynamodb.put(params).promise();
    console.log(`Inserted item for ${key} into DynamoDB.`);

    return {
        statusCode: 200,
        body: JSON.stringify('Success!'),
    };
};
