import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo_firbase_test/models/news_model.dart';
import 'package:todo_firbase_test/widgets/RestAPIPages/Screens/restapi_newsdetails.dart';

class NewsItemList extends StatelessWidget {
  final NewsModel newsModel;
  const NewsItemList({
    super.key,
    required this.newsModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, 
        MaterialPageRoute(builder: (context)=> RestapiNewsdetails(newsModel: newsModel))
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: 250,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              imageUrl: newsModel.urlToImage.toString(),
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(newsModel.source!.name.toString()),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red,
                  ),
                ),
                Text(newsModel.publishedAt.toString()),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text(newsModel.author == null
                ? ""
                : " Written By " + newsModel.author.toString()),
            SizedBox(
              height: 12,
            ),
            Text(newsModel.title.toString())
          ],
        ),
      ),
    );
  }
}
