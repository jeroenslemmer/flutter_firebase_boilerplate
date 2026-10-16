import 'dart:convert';
import 'dart:io';

const _defaultLocale = 'en';
const _defaultPort = 8787;
const _sourceLocale = 'nl';
const _arbDirectoryPath = 'lib/l10n';
const _editorAssetPath = 'tool/translation_editor/index.html';

final _placeholderPattern = RegExp(r'\{([A-Za-z_][A-Za-z0-9_]*)\s*(?:[,}])');

Future<void> main(List<String> arguments) async {
  final options = _EditorOptions.parse(arguments);
  final sourceFile = File('$_arbDirectoryPath/app_$_sourceLocale.arb');
  final targetFile = File('$_arbDirectoryPath/app_${options.locale}.arb');
  final editorAsset = File(_editorAssetPath);

  for (final file in [sourceFile, targetFile, editorAsset]) {
    if (!file.existsSync()) {
      stderr.writeln('Verplicht bestand ontbreekt: ${file.path}');
      exitCode = 1;
      return;
    }
  }

  final editor = _TranslationEditor(
    sourceFile: sourceFile,
    targetFile: targetFile,
    editorAsset: editorAsset,
    targetLocale: options.locale,
  );

  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    options.port,
    shared: false,
  );
  final editorUri = Uri.parse('http://127.0.0.1:${server.port}/');

  stdout.writeln('Starting translation editor...');
  stdout.writeln('Translation editor ready: $editorUri');
  stdout.writeln('Stop de editor met Ctrl+C.');

  if (options.openBrowser) {
    await _openBrowser(editorUri);
  }

  await for (final request in server) {
    await editor.handle(request, editorUri.origin);
  }
}

class _EditorOptions {
  const _EditorOptions({
    required this.locale,
    required this.port,
    required this.openBrowser,
  });

  final String locale;
  final int port;
  final bool openBrowser;

  static _EditorOptions parse(List<String> arguments) {
    var locale = _defaultLocale;
    var port = _defaultPort;
    var openBrowser = true;

    for (var index = 0; index < arguments.length; index++) {
      final argument = arguments[index];
      switch (argument) {
        case '--locale':
          locale = _valueAfter(arguments, ++index, argument);
        case '--port':
          final value = _valueAfter(arguments, ++index, argument);
          port =
              int.tryParse(value) ??
              (throw FormatException('Ongeldige poort: $value'));
        case '--no-open':
          openBrowser = false;
        case '--help':
        case '-h':
          stdout.writeln(
            'Gebruik: dart run tool/translation_editor.dart '
            '[--locale en] [--port 8787] [--no-open]',
          );
          exit(0);
        default:
          throw FormatException('Onbekend argument: $argument');
      }
    }

    if (!RegExp(r'^[A-Za-z]{2,3}(?:_[A-Za-z0-9]{2,8})*$').hasMatch(locale)) {
      throw FormatException('Ongeldige locale: $locale');
    }
    if (locale == _sourceLocale) {
      throw const FormatException(
        'De Nederlandse brontaal is alleen-lezen in de vertaaleditor.',
      );
    }
    if (port < 1024 || port > 65535) {
      throw FormatException('Poort moet tussen 1024 en 65535 liggen: $port');
    }

    return _EditorOptions(locale: locale, port: port, openBrowser: openBrowser);
  }

  static String _valueAfter(List<String> arguments, int index, String option) {
    if (index >= arguments.length) {
      throw FormatException('Waarde ontbreekt na $option.');
    }
    return arguments[index];
  }
}

class _TranslationEditor {
  const _TranslationEditor({
    required this.sourceFile,
    required this.targetFile,
    required this.editorAsset,
    required this.targetLocale,
  });

  final File sourceFile;
  final File targetFile;
  final File editorAsset;
  final String targetLocale;

  Future<void> handle(HttpRequest request, String allowedOrigin) async {
    try {
      if (request.method == 'GET' && request.uri.path == '/') {
        await _sendText(
          request.response,
          editorAsset.readAsStringSync(),
          contentType: ContentType.html,
        );
        return;
      }

      if (request.method == 'GET' && request.uri.path == '/api/catalog') {
        await _sendJson(request.response, _catalogResponse());
        return;
      }

      if (request.method == 'POST' && request.uri.path == '/api/save') {
        final origin = request.headers.value('origin');
        if (origin != null && origin != allowedOrigin) {
          await _sendError(request.response, 403, 'Ongeldige request origin.');
          return;
        }

        final body = await utf8.decoder.bind(request).join();
        final decoded = jsonDecode(body);
        if (decoded is! Map<String, Object?>) {
          await _sendError(request.response, 400, 'Ongeldig verzoek.');
          return;
        }

        final translations = decoded['translations'];
        if (translations is! Map<String, Object?>) {
          await _sendError(request.response, 400, 'Vertalingen ontbreken.');
          return;
        }

        final result = _saveTranslations(translations);
        await _sendJson(request.response, result);
        return;
      }

      if (request.method == 'GET' && request.uri.path == '/favicon.ico') {
        request.response.statusCode = HttpStatus.noContent;
        await request.response.close();
        return;
      }

      await _sendError(request.response, 404, 'Niet gevonden.');
    } on FormatException catch (error) {
      await _sendError(request.response, 400, error.message);
    } catch (error, stackTrace) {
      stderr.writeln('Editorfout: $error\n$stackTrace');
      await _sendError(request.response, 500, 'Opslaan is mislukt.');
    }
  }

  Map<String, Object?> _catalogResponse() {
    final source = _readCatalog(sourceFile);
    final target = _readCatalog(targetFile);
    final sourceMessages = _messages(source);
    final targetMessages = _messages(target);

    _requireMatchingKeys(
      sourceMessages.keys.toSet(),
      targetMessages.keys.toSet(),
    );

    return {
      'sourceLocale': _sourceLocale,
      'targetLocale': targetLocale,
      'targetFile': targetFile.path,
      'messages': [
        for (final entry in sourceMessages.entries)
          {
            'key': entry.key,
            'source': entry.value,
            'translation': targetMessages[entry.key],
            'description': _description(source, entry.key),
            'placeholders': _placeholders(entry.value).toList()..sort(),
          },
      ],
    };
  }

  Map<String, Object?> _saveTranslations(Map<String, Object?> submitted) {
    final source = _readCatalog(sourceFile);
    final target = _readCatalog(targetFile);
    final sourceMessages = _messages(source);
    final targetMessages = _messages(target);
    final expectedKeys = sourceMessages.keys.toSet();

    _requireMatchingKeys(expectedKeys, targetMessages.keys.toSet());
    _requireMatchingKeys(expectedKeys, submitted.keys.toSet());

    final normalized = <String, String>{};
    for (final key in expectedKeys) {
      final value = submitted[key];
      if (value is! String) {
        throw FormatException('$key moet tekst bevatten.');
      }
      if (value.trim().isEmpty) {
        throw FormatException('$key heeft nog geen vertaling.');
      }

      final expectedPlaceholders = _placeholders(sourceMessages[key]!);
      final actualPlaceholders = _placeholders(value);
      if (!_sameSet(expectedPlaceholders, actualPlaceholders)) {
        throw FormatException(
          '$key gebruikt niet dezelfde placeholders als de brontekst. '
          'Verwacht: ${expectedPlaceholders.join(', ')}; '
          'gevonden: ${actualPlaceholders.join(', ')}.',
        );
      }
      normalized[key] = value;
    }

    for (final entry in normalized.entries) {
      target[entry.key] = entry.value;
    }

    const encoder = JsonEncoder.withIndent('  ');
    targetFile.writeAsStringSync('${encoder.convert(target)}\n', flush: true);

    return {
      'ok': true,
      'savedCount': normalized.length,
      'targetFile': targetFile.path,
    };
  }

  void _requireMatchingKeys(Set<String> expected, Set<String> actual) {
    final missing = expected.difference(actual).toList()..sort();
    final extra = actual.difference(expected).toList()..sort();
    if (missing.isNotEmpty || extra.isNotEmpty) {
      throw FormatException(
        'Catalogussleutels komen niet overeen. '
        'Ontbrekend: ${missing.join(', ')}. '
        'Onbekend: ${extra.join(', ')}.',
      );
    }
  }
}

Map<String, Object?> _readCatalog(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw FormatException('${file.path} bevat geen geldig ARB-object.');
  }
  return decoded;
}

Map<String, String> _messages(Map<String, Object?> catalog) {
  return {
    for (final entry in catalog.entries)
      if (!entry.key.startsWith('@') && entry.value is String)
        entry.key: entry.value! as String,
  };
}

String _description(Map<String, Object?> source, String key) {
  final metadata = source['@$key'];
  if (metadata is Map<String, Object?> && metadata['description'] is String) {
    return metadata['description']! as String;
  }
  return '';
}

Set<String> _placeholders(String message) {
  return _placeholderPattern
      .allMatches(message)
      .map((match) => match.group(1)!)
      .toSet();
}

bool _sameSet(Set<String> left, Set<String> right) {
  return left.length == right.length && left.containsAll(right);
}

Future<void> _sendJson(
  HttpResponse response,
  Map<String, Object?> payload,
) async {
  response.headers.contentType = ContentType.json;
  response.headers.set('Cache-Control', 'no-store');
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.write(jsonEncode(payload));
  await response.close();
}

Future<void> _sendText(
  HttpResponse response,
  String body, {
  required ContentType contentType,
}) async {
  response.headers.contentType = contentType;
  response.headers.set('Cache-Control', 'no-store');
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set(
    'Content-Security-Policy',
    "default-src 'self'; style-src 'unsafe-inline'; script-src 'unsafe-inline'",
  );
  response.write(body);
  await response.close();
}

Future<void> _sendError(
  HttpResponse response,
  int statusCode,
  String message,
) async {
  response.statusCode = statusCode;
  await _sendJson(response, {'ok': false, 'error': message});
}

Future<void> _openBrowser(Uri uri) async {
  try {
    if (Platform.isMacOS) {
      await Process.start('open', [uri.toString()]);
    } else if (Platform.isWindows) {
      await Process.start('cmd', ['/c', 'start', '', uri.toString()]);
    } else if (Platform.isLinux) {
      await Process.start('xdg-open', [uri.toString()]);
    }
  } on ProcessException catch (error) {
    stderr.writeln('Browser kon niet automatisch openen: ${error.message}');
  }
}
