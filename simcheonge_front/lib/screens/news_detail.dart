import 'package:flutter/material.dart';
import 'package:simcheonge_front/models/news_detail_model.dart';
import 'package:simcheonge_front/services/news_detail_api.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsUrl;

  const NewsDetailScreen({super.key, required this.newsUrl});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late Future<NewsDetail> _newsDetailFuture;
  bool _isSummarized = true;

  @override
  void initState() {
    super.initState();
    _newsDetailFuture = fetchNewsDetail(widget.newsUrl);
  }

  void _toggleContent() {
    setState(() {
      _isSummarized = !_isSummarized;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('원문 보기'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: FutureBuilder<NewsDetail>(
        future: _newsDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    '뉴스 기사를 불러오는 중입니다...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            // 데이터 로딩 실패
            return const Center(
              child: Text(
                "데이터를 불러오는데 실패했습니다.",
                style: TextStyle(fontSize: 16),
              ),
            );
          } else if (snapshot.hasData) {
            // 데이터 로딩 성공
            final newsDetail = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    newsDetail.data!.title!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    newsDetail.data!.time!,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      newsDetail.data!.reporter!,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isSummarized
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: newsDetail.data!.summarizedContent != null
                              ? Text(
                                  newsDetail.data!.summarizedContent!,
                                  style: const TextStyle(fontSize: 18),
                                )
                              : const Text(
                                  '기사 요약이 없습니다',
                                  style: TextStyle(fontSize: 18),
                                ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Text(
                            newsDetail.data!.originalContent!,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            _toggleContent();
                          },
                          child: Text(
                            _isSummarized ? '전문 읽기' : '요약 보기',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      if (!_isSummarized)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              launchUrl(Uri.parse(widget.newsUrl));
                            },
                            child: const Text('원문 페이지로 이동하기',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            );
          } else {
            // 데이터가 없음
            return const Center(
              child: Text(
                "데이터가 없습니다.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
