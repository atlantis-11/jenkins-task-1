from src import function


def test_handler():
    name = 'Bob'

    test_event = {
        'queryStringParameters': {
            'name': name,
        },
    }

    expected_result = f'Hello {name}'

    actual_result = function.handler(test_event, None)

    assert actual_result['statusCode'] == 200
    assert expected_result in actual_result['body']


def test_handler_no_name():
    test_event = {'queryStringParameters': {}}

    result = function.handler(test_event, None)

    assert result['statusCode'] == 400
