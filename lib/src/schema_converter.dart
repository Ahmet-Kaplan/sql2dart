import 'dart:io';

import 'package:sql2dart/src/logger.dart';
import 'package:sql2dart/src/table_reader.dart';
import 'package:sql2dart/src/types_generator.dart';
import 'package:path/path.dart' as p;

import 'types.dart';

class SchemaConverter {
  final String connectionString;
  final Directory outputDirectory;

  /// the schema to generate data classes from
  final String schemaName;

  /// an optional list of tables to generate the data classes fromƒ
  final List<String>? tableNames;

  final _tables = <Table>[];

  SchemaConverter({
    required this.connectionString,
    required this.outputDirectory,
    required this.schemaName,
    this.tableNames,
  });

  Future<void> convert() async {
    // read tables
    Log.trace('started reading tables');
    var progress = Log.progress('reading tables');
    await _readTables();
    progress.finish(message: 'found ${_tables.length} - tables');

    // generate source code
    Log.trace('generating dart classes');
    progress = Log.progress('generating dart source code for tables');
    await _addDartSourceToTables();
    progress.finish(message: 'sources were generated.');

    // write sources to output directory
    Log.trace('writing files to output directory');
    progress = Log.progress('generating dart source code for tables');
    await _writeFilesToOutputDirectory();
    progress.finish(message: 'files were written at ${outputDirectory.path}');
  }

  Future<void> _readTables() async {
    final reader = TablesReader.fromConnectionString(connectionString);
    Log.trace('connecting to database');
    await reader.connect();
    Log.trace('calling TablesReader.getTables');
    final tables = await reader.getTables(schemaName: schemaName, tableNames: tableNames);
    Log.trace('disconnecting the database');
    await reader.disconnect();
    _tables.clear();
    _tables.addAll(tables);
  }

  Future<void> _addDartSourceToTables() async {
    final generator = TypesGenerator(
      outputDirectory: outputDirectory,
      tables: _tables,
    );
    await generator.addDartSourceToTables();
  }

  Future<void> _writeFilesToOutputDirectory() async {
    final futures = <Future>[];
    Log.trace('writing files');
    for (final table in _tables) {
      final file = File(p.join(outputDirectory.path, table.tableName + '.g.dart'));
      futures.add(file.create(recursive: true).then((value) => file.writeAsString(table.source)));
    }

    await Future.wait(futures);
  }
}
