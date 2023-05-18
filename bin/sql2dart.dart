import 'dart:io';

import 'package:sql2dart/sql2dart.dart';

void main(List<String> args) async {
  try {
    await SchemaDartRunner().run(args);
    exitCode = 0;
  } catch (e) {
    print(e);
    exitCode = 1;
  }
}
