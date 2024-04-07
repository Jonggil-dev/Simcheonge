import 'package:flutter/material.dart';
import 'package:simcheonge_front/widgets/side_app_bar.dart';

class BookmarkPostScreen extends StatefulWidget {
  const BookmarkPostScreen({super.key});

  @override
  _BookmarkPostScreenState createState() => _BookmarkPostScreenState();
}

class _BookmarkPostScreenState extends State<BookmarkPostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Scaffold key 추가

  List<String> bookmarkedItems =
      List<String>.generate(20, (i) => 'Item ${i + 1}'); // 더미 데이터 20개 생성
  String searchQuery = ''; // 검색 쿼리를 저장하는 문자열

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Scaffold에 key 할당

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
          print('끔');
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
        print('끔');

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
