class HttpConfig {
  final String authority = '10.0.2.2:7185'; //change 7185 to your swagger url
  final String unencodedPath = 'api/tasks';
  final Map<String, dynamic> queryParameters = {
    'pageSize': '50',
    'pageNumber': '1'
  };
}
