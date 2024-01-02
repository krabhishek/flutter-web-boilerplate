import 'package:flutter_web_server/flutter_web_server.dart';

void main(List<String> arguments) async {
  const port = 8080;

  final app = Router();
  app.all('/<name|.*>', fallback('/../build/web/index.html'));

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app.call);

  var server = await serve(handler, InternetAddress.anyIPv4, port);
  server.autoCompress = true;

  print('HTTP Service running on port $port');
}
