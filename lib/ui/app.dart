import 'package:flutter/material.dart';
import 'package:repository/config/routes.dart';

class GitRepositoryApp extends StatelessWidget {
  const GitRepositoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: NavigationManager.routes,
    );
  }
}
