

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repository/ui/Home/HomeModel.dart';
import 'package:http/http.dart' as http;
import 'package:repository/utils/DatabaseHandler.dart';

class HomeController {
  String baseurl = const String.fromEnvironment('baseUrl');

  Future<List<Map<String, dynamic>>> loadRepositories(DateTime date) async{
     final dateString = date.toIso8601String().split('T').first;
    var response = await http.get(Uri.parse("${baseurl}search/repositories?q=created:>$dateString&sort=stars&order=desc"));
    if(response.statusCode == 200){
    final gitHubRepositories = gitHubRepositoriesFromJson(response.body);
    await DatabaseHandler().insertRepositories(gitHubRepositories.items!, date);
    List<Map<String, dynamic>> data = await DatabaseHandler().getUserRepositories(date);
    return data;
    } else{
      throw Exception(response.reasonPhrase);
    }
  }
}

  final homeProvider = Provider<HomeController>((ref) => HomeController());

final getUserDetails = FutureProvider.family<List<Map<String, dynamic>>, DateTime>((ref, date) async {
  return ref.watch(homeProvider).loadRepositories(date);
});


