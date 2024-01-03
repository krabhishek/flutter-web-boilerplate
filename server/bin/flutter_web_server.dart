import 'package:flutter_web_server/flutter_web_server.dart';
import 'dart:async' show runZonedGuarded;
import 'package:args/args.dart';

void main(List<String> arguments) async {
  final parser = _getParser();
  int port;
  String indexHtmlFile;

  try {
    final result = parser.parse(arguments);
    port = int.parse(result['port'] as String);
    indexHtmlFile = result['index-file'] as String;
  } on FormatException catch (e) {
    stderr
      ..writeln(e.message)
      ..writeln(parser.usage);

    exit(64);
  }
  final app = Router();
  app.all('/<name|.*>', fallback('/$indexHtmlFile'));

  runZonedGuarded(() async {
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(handleCors())
        .addHandler(app.call);

    var server = await serve(handler, InternetAddress.anyIPv4, port);
    server.autoCompress = true;

    print('HTTP Service running on port $port');

    print("Serving $indexHtmlFile on port $port");
  }, (e, stackTrace) => print('Server error: $e $stackTrace'));
}

ArgParser _getParser() => ArgParser()
  ..addOption('port', abbr: 'p', defaultsTo: '8080')
  ..addOption('index-file', abbr: 'f', defaultsTo: '../build/web/index.html');
