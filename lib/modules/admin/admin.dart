import 'package:flutter/material.dart';

import '../../imports.dart';
import 'reported_posts.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.Admin),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(t.ReportedPosts),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Get.to(ReportedPostsPage()),
          ),
        ],
      ),
    );
  }
}
