import 'dart:convert';
import 'dart:io';

const _arbDirectoryPath = 'lib/l10n';
const _templateFileName = 'app_nl.arb';

final _placeholderPattern = RegExp(r'\{([A-Za-z_][A-Za-z0-9_]*)\s*(?:[,}])');

void main() {
  final failures = <String>[];
  final arbDirectory = Directory(_arbDirectoryPath);

  if (!arbDirectory.existsSync()) {
    stderr.writeln('Vertaalmap $_arbDirectoryPath bestaat niet.');
    exitCode = 1;
    return;
  }

  final files =
      arbDirectory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));

  final templateFile = File('$_arbDirectoryPath/$_templateFileName');
  if (!templateFile.existsSync()) {
    stderr.writeln('Brontaalbestand ${templateFile.path} bestaat niet.');
    exitCode = 1;
    return;
  }

  final catalogs = <String, Map<String, Object?>>{};
  for (final file in files) {
    final catalog = _readCatalog(file, failures);
    if (catalog != null) {
      catalogs[file.path] = catalog;
    }
  }

  final template = catalogs[templateFile.path];
  if (template == null) {
    _finish(failures);
    return;
  }

  final templateMessages = _messages(template);
  final templateKeys = templateMessages.keys.toSet();

  for (final entry in templateMessages.entries) {
    final key = entry.key;
    final metadata = template['@$key'];

    if (metadata is! Map<String, Object?>) {
      failures.add('$_templateFileName: metadata @$key ontbreekt.');
      continue;
    }

    final description = metadata['description'];
    if (description is! String || description.trim().isEmpty) {
      failures.add('$_templateFileName: description voor $key ontbreekt.');
    }

    final placeholders = _placeholders(entry.value);
    final metadataPlaceholders = metadata['placeholders'];
    final declaredPlaceholders = metadataPlaceholders is Map<String, Object?>
        ? metadataPlaceholders.keys.toSet()
        : <String>{};

    _compareSets(
      expected: placeholders,
      actual: declaredPlaceholders,
      missingLabel: 'niet in metadata gedeclareerde placeholders',
      extraLabel: 'ongebruikte metadata-placeholders',
      location: '$_templateFileName:$key',
      failures: failures,
    );

    if (metadataPlaceholders is Map<String, Object?>) {
      for (final placeholder in metadataPlaceholders.entries) {
        final details = placeholder.value;
        if (details is! Map<String, Object?> ||
            details['type'] is! String ||
            details['description'] is! String ||
            (details['description'] as String).trim().isEmpty) {
          failures.add(
            '$_templateFileName:$key: placeholder ${placeholder.key} '
            'mist type of description.',
          );
        }
      }
    }
  }

  for (final catalogEntry in catalogs.entries) {
    final file = File(catalogEntry.key);
    final catalog = catalogEntry.value;
    final fileName = file.uri.pathSegments.last;
    final localeMatch = RegExp(r'^app_([A-Za-z_]+)\.arb$').firstMatch(fileName);

    if (localeMatch == null) {
      failures.add('$fileName: bestandsnaam moet app_<locale>.arb zijn.');
      continue;
    }

    final expectedLocale = localeMatch.group(1)!;
    if (catalog['@@locale'] != expectedLocale) {
      failures.add(
        '$fileName: @@locale moet "$expectedLocale" zijn, maar is '
        '"${catalog['@@locale']}".',
      );
    }

    if (file.path == templateFile.path) {
      continue;
    }

    final messages = _messages(catalog);
    final messageKeys = messages.keys.toSet();
    _compareSets(
      expected: templateKeys,
      actual: messageKeys,
      missingLabel: 'ontbrekende vertaalsleutels',
      extraLabel: 'onbekende vertaalsleutels',
      location: fileName,
      failures: failures,
    );

    for (final key in templateKeys.intersection(messageKeys)) {
      _compareSets(
        expected: _placeholders(templateMessages[key]!),
        actual: _placeholders(messages[key]!),
        missingLabel: 'ontbrekende placeholders',
        extraLabel: 'onbekende placeholders',
        location: '$fileName:$key',
        failures: failures,
      );
    }
  }

  _finish(
    failures,
    localeCount: catalogs.length,
    messageCount: templateKeys.length,
  );
}

Map<String, Object?>? _readCatalog(File file, List<String> failures) {
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, Object?>) {
      failures.add('${file.path}: het ARB-hoofdniveau moet een object zijn.');
      return null;
    }
    return decoded;
  } on FormatException catch (error) {
    failures.add('${file.path}: ongeldige ARB/JSON: ${error.message}.');
    return null;
  }
}

Map<String, String> _messages(Map<String, Object?> catalog) {
  return {
    for (final entry in catalog.entries)
      if (!entry.key.startsWith('@') && entry.value is String)
        entry.key: entry.value! as String,
  };
}

Set<String> _placeholders(String message) {
  return _placeholderPattern
      .allMatches(message)
      .map((match) => match.group(1)!)
      .toSet();
}

void _compareSets({
  required Set<String> expected,
  required Set<String> actual,
  required String missingLabel,
  required String extraLabel,
  required String location,
  required List<String> failures,
}) {
  final missing = expected.difference(actual).toList()..sort();
  final extra = actual.difference(expected).toList()..sort();

  if (missing.isNotEmpty) {
    failures.add('$location: $missingLabel: ${missing.join(', ')}.');
  }
  if (extra.isNotEmpty) {
    failures.add('$location: $extraLabel: ${extra.join(', ')}.');
  }
}

void _finish(List<String> failures, {int? localeCount, int? messageCount}) {
  if (failures.isNotEmpty) {
    stderr.writeln('Vertaalcontrole mislukt:');
    for (final failure in failures) {
      stderr.writeln('- $failure');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'Vertalingen geldig: $messageCount teksten in $localeCount talen.',
  );
}
