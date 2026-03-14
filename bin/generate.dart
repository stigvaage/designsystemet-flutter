import 'dart:io';
import 'package:komponentbibliotek_flutter/src/generator/dart_emitter.dart';
import 'package:komponentbibliotek_flutter/src/generator/dtcg_parser.dart';

void main(List<String> args) {
  String? tokensDir;
  String? outputDir;

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--tokens-dir':
        if (i + 1 < args.length) tokensDir = args[++i];
      case '--output':
        if (i + 1 < args.length) outputDir = args[++i];
      case '--help':
      case '-h':
        _printUsage();
        exit(0);
    }
  }

  if (tokensDir == null || outputDir == null) {
    stderr.writeln('Error: --tokens-dir and --output are required.');
    _printUsage();
    exit(1);
  }

  try {
    final parser = DtcgParser();
    final themes = parser.parse(tokensDir!);

    final outDir = Directory(outputDir!);
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }

    final emitter = DartEmitter();
    for (final theme in themes) {
      final code = emitter.emit(theme);
      final fileName = 'ds_theme_${theme.name.replaceAll('-', '_')}.dart';
      final outFile = File('${outDir.path}/$fileName');
      outFile.writeAsStringSync(code);
      stdout.writeln('Generated: ${outFile.path}');
    }

    stdout.writeln('Successfully generated ${themes.length} theme file(s).');
    exit(0);
  } on DtcgParseException catch (e) {
    stderr.writeln('Parse error: ${e.message}');
    exit(3);
  } catch (e) {
    stderr.writeln('Unexpected error: $e');
    exit(2);
  }
}

void _printUsage() {
  stdout.writeln('Usage: dart run komponentbibliotek_flutter:generate \\');
  stdout.writeln('  --tokens-dir <path-to-design-tokens> \\');
  stdout.writeln('  --output <output-directory>');
}
