def handler(event, context):
    print("Lambda function triggered by EventBridge")
    return {
        'statusCode': 200,
        'body': 'Success'
    }
