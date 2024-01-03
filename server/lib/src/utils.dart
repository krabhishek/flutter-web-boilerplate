import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';

Middleware handleCors() {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  };

  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders);
      }
      return null;
    },
    responseHandler: (Response response) {
      return response.change(headers: corsHeaders);
    },
  );
}

Handler fallback(String indexPath) => (Request request) {
      final rawPath = Directory.current.path + indexPath;
      final filePath = Uri.tryParse(Directory.current.path + indexPath);
      final indexFile = File(filePath.toString()).readAsStringSync();
      if (p.extension(rawPath) == '.js') {
        return Response.ok(indexFile,
            headers: {'content-type': 'application/javascript'});
      }
      return Response.ok(indexFile, headers: {'content-type': 'text/html'});
    };
