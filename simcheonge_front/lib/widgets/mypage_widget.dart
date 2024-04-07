import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<String> bookmarkedItems = []; // 북마크한 항목을 저장하는 리스트
  String searchQuery = ''; // 검색 쿼리를 저장하는 문자열

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              showSearch(
                context: context,
                delegate: DataSearch(bookmarkedItems),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: bookmarkedItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(bookmarkedItems[index]),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                setState(() {
                  bookmarkedItems.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<String> items;

  DataSearch(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? items
        : items.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}
