
import 'package:flutter/material.dart';
import 'package:todo_firbase_test/widgets/RestAPIPages/Screens/widgets/all_news.dart';
import 'package:todo_firbase_test/widgets/RestAPIPages/Screens/widgets/braking_news.dart';

class RestapiShow extends StatefulWidget {
  const RestapiShow({super.key});

  @override
  State<RestapiShow> createState() => _RestapiShowState();
}

class _RestapiShowState extends State<RestapiShow> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          
          bottom: TabBar(
            tabs: [
              Tab(text: 'Breaking',),
              Tab(text: 'All News',),
            ]),
        ),
        body:TabBarView(
          children: [
            BreakingNews(),
            AllNews(),
          ],
        ) ,
      ),
    );
  }
}