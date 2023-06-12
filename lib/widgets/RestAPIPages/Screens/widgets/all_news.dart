
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo_firbase_test/models/news_model.dart';
import 'package:todo_firbase_test/services/api_service.dart';
import 'package:todo_firbase_test/widgets/RestAPIPages/Screens/widgets/news_item_list.dart';

class AllNews extends StatefulWidget {
  const AllNews({super.key});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
   ApiService apiService = ApiService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: apiService.getAllNews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<NewsModel> articlelist = snapshot.data ?? [];
              return ListView.builder(
                itemBuilder: (context, index) {
                  return NewsItemList(
                    newsModel: articlelist[index],
                  );
                },
                itemCount: articlelist.length,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          ),
    );
  }
}