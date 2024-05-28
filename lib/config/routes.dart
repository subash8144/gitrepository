import 'package:flutter/material.dart';
import 'package:repository/ui/Home/HomeView.dart';

class AppRoutes {
  static const String initial = '/';
}

class NavigationManager {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.initial: (context) => GitRepositoryHome(),
  };
}