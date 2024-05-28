import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repository/constants/TextConstants.dart';
import 'package:repository/ui/Home/HomeModel.dart';
import 'package:repository/ui/Home/HomeViewModel.dart';
import 'package:repository/utils/DatabaseHandler.dart';

class GitRepositoryHome extends ConsumerWidget {
  GitRepositoryHome({super.key});

  DateTime date = DateTime(2022, 4, 29);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(getUserDetails(date));
    final gitUsers = ref.watch(getUserDetails(date));
    return gitUsers.when(
      data: (userList) {
        return RefreshIndicator(
          onRefresh: () async {
            date = DateTime.now();
            ref.watch(getUserDetails(date));
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(kHomeTitle),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    const snackBar = SnackBar(
                      content: Text(kPullToRefresh),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: const Icon(Icons.info),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(userList[index]['name'], style: const TextStyle(color: Colors.white),),
                      subtitle: Text(userList[index]['desc'], style: const TextStyle(color: Colors.white),),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      error: (err, s) => Scaffold(
        body: Center(
          child: Text(
            err.toString(),
          ),
        ),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
