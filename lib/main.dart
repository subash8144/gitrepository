import 'package:flutter/material.dart';
import 'package:repository/ui/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repository/utils/DatabaseHandler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHandler().initializeDB();
  runApp(const ProviderScope(child: GitRepositoryApp()));
}