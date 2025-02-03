import cowsay


def handler(event, context):
    if 'name' not in event['queryStringParameters']:
        return {
            'statusCode': 400,
            'body': '`name` parameter not provided\n',
        }

    name = event['queryStringParameters']['name']

    return {
        'statusCode': 200,
        'body': cowsay.get_output_string('cow', f'Hello {name}') + '\n',
    }
