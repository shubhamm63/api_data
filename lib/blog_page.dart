import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShubhamBlogs extends StatefulWidget {
  @override
  _ShubhamBlogsState createState() => _ShubhamBlogsState();
}

class _ShubhamBlogsState extends State<ShubhamBlogs> {
  List<dynamic> posts = [];

  Future<void> fetchPosts() async {
    final String apiUrl = 'https://api.hive.blog/';
    final Map<String, dynamic> requestData = {
      "id": 1,
      "jsonrpc": "2.0",
      "method": "bridge.get_ranked_posts",
      "params": {
        "sort": "trending",
        "tag": "",
        "observer": "hive.blog",
      }
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'accept': 'application/json, text/plain, */*',
        'content-type': 'application/json',
      },
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> receivedPosts = jsonData['result'];

      setState(() {
        posts = receivedPosts;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shubham Blogs Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          //For Image you have uncomment it
          // final imageUrl = post['image_url'];
          return Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 10,
              child: ListTile(
                // leading: imageUrl != null
                //     ? Image.network(
                //         imageUrl,
                //         width: 50,
                //         height: 50,
                //       )
                //     : SizedBox.shrink(),
                title: Text(
                  'Title: \t\t ${post['title'] ?? 'No Title'}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                subtitle: Text(
                  'Author: \t\t ${post['author'] ?? 'No Author'}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.pink),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
