import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/screens/policy_detail_screen.dart';
import 'dart:convert';
import 'package:simcheonge_front/screens/search_filter.dart';
import 'dart:ui';
import 'package:simcheonge_front/models/search_model.dart';
import 'package:simcheonge_front/services/search_api.dart';
import 'package:simcheonge_front/models/filter_model.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Content> _filteredPolices = [];
  int _currentPage = 0;
  bool _isFetching = false;
  bool _hasMore = true; // 더 불러올 데이터가 있는지
  List<CategoryList> _selectedFilters = [];
  final int _totalPages = 0;
  bool _isLoading = false;

  late SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _initializeSpeech();
    _loadSelectedFilters();
    _controller.addListener(_searchListener);
    _scrollController.addListener(_scrollListener);

    _fetchData(); // 초기 데이터 로드
  }

  Future<void> _loadSelectedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final String? selectedFiltersStr = prefs.getString('selectedFilters');
    if (selectedFiltersStr != null) {
      final List<dynamic> selectedFiltersJson = jsonDecode(selectedFiltersStr);
      final List<CategoryList> loadedFilters =
          selectedFiltersJson.map((e) => CategoryList.fromJson(e)).toList();
      setState(() {
        _selectedFilters.clear();
        _selectedFilters.addAll(loadedFilters);
      });
    }
  }

  void _initializeSpeech() async {
    bool isAvailable = await _speech.initialize();
    if (isAvailable) {
      // 음성 입력이 사용 가능한 경우
      print('Speech recognition initialized successfully.');
    } else {
      // 음성 입력이 사용 불가능한 경우
      print('Error initializing speech recognition.');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _searchListener() async {
    // 검색 조건 업데이트와 검색 결과 갱신만 수행합니다.
    await _loadSelectedFilters();
    _updateSearchConditions();
    _filteredPolices.clear();
    _currentPage = 0;
    _hasMore = true;
    _fetchData();
  }

  void _updateSearchConditions() async {
    final prefs = await SharedPreferences.getInstance();

    // 'selectedFilters' 정보를 불러옵니다.
    String selectedFiltersString = prefs.getString('selectedFilters') ?? '[]';
    List<dynamic> selectedFiltersJson = jsonDecode(selectedFiltersString);

    // SharedPreferences에서 'filters' 정보를 불러옵니다.
    String filtersString = prefs.getString('filters') ?? '[]';
    List<dynamic> filtersJson = jsonDecode(filtersString);

    // 'selectedFilters'를 CategoryList 객체 리스트로 변환합니다.
    List<CategoryList> loadedSelectedFilters =
        selectedFiltersJson.map((e) => CategoryList.fromJson(e)).toList();

    setState(() {
      // '_selectedFilters' 상태를 업데이트합니다.
      _selectedFilters.clear();
      // 이게 필터 항목 보여주고있음
      // _selectedFilters.addAll(loadedSelectedFilters);

      // 이게 검색 결과에서 필터 지우는 기능
      for (var filterJson in filtersJson) {
        _selectedFilters.add(CategoryList.fromJson(filterJson));
      }
    });
  }

  void _openFilterScreen() async {
    // 필터 화면에서 필터를 선택하고 돌아올 때마다 검색을 다시 실행하도록 수정
    final returnedFilters = await Navigator.push<List<CategoryList>>(
      context,
      MaterialPageRoute(builder: (context) => const FilterScreen()),
    );

    if (returnedFilters != null) {
      // 필터가 변경되었을 때만 필터를 업데이트하고 검색을 실행

      await saveSelectedFilters(returnedFilters);
      _loadSelectedFilters(); // 변경된 필터를 UI에 반영
      _searchListener(); // 필터를 적용하고 검색 실행
    }
  }

  Future<void> saveSelectedFilters(List<CategoryList> selectedFilters) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    // 선택된 필터들을 JSON 문자열로 변환
    String selectedFiltersJson =
        jsonEncode(selectedFilters.map((filter) => filter.toJson()).toList());
    // 'selectedFilters' 키를 사용하여 저장
    await prefs.setString('selectedFilters', selectedFiltersJson);
    // 저장된 데이터 로그로 확인
    setState(() {
      _isLoading = false;
    });
    print("Saved filters: $selectedFiltersJson");
  }

  Future<List<CategoryList>> loadSelectedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    String? selectedFiltersJson = prefs.getString('selectedFilters');
    if (selectedFiltersJson != null) {
      List<dynamic> decodedFilters = jsonDecode(selectedFiltersJson);
      return decodedFilters
          .map((filterJson) => CategoryList.fromJson(filterJson))
          .toList();
    }
    return [];
  }

  void _fetchData() async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String filtersString = prefs.getString('filters') ?? '[]';
    List<dynamic> filtersJson = jsonDecode(filtersString);
    List<Map<String, dynamic>> filters = filtersJson.map((filter) {
      return {
        "code": filter['code'],
        "number": int.tryParse(filter['number'].toString())
      };
    }).toList();

    // SharedPreferences에서 날짜 정보 불러오기
    final String? startDateStr = prefs.getString('startDate');
    final String? endDateStr = prefs.getString('endDate');
    // 요청 본문 구성
    Map<String, dynamic> requestBody = {
      "keyword": _controller.text,
      "list": filters,
    };

    if (startDateStr != null && endDateStr != null) {
      requestBody.addAll({
        "startDate": startDateStr,
        "endDate": endDateStr,
      });
    }

    // 최종 요청 본문 확인
    print("Final request body being sent: ${jsonEncode(requestBody)}");

    try {
      final SearchModel response = await SearchApi().searchPolicies(
        requestBody, // 수정된 부분
        _currentPage,
      );

      setState(() {
        if (response.data?.content?.isEmpty ?? true) {
          _hasMore = false;
        } else {
          _currentPage++;
          _filteredPolices.addAll(response.data!.content!);
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      _isFetching = false;
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _hasMore) {
      // 추가 검색 결과를 가져올 수 있는지 여부를 확인합니다.
      _fetchData(); // 다음 페이지의 데이터를 불러옵니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasFilters = _selectedFilters.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text('검색',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 2),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '검색어를 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    _startListening();
                  },
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchListener();
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Visibility(
              visible: hasFilters,
              child: SizedBox(
                height: 40, // 필터 목록의 높이 설정
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedFilters.length,
                  itemBuilder: (context, index) {
                    final filter = _selectedFilters[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Chip(
                        label: Text(filter.name ?? '로딩중..'),
                        onDeleted: () => removeFilter(filter),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5, 15.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _openFilterScreen, // 필터 화면을 여는 메서드 호출
                  child: const Row(
                    children: [
                      Icon(Icons.filter_alt, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('필터',
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _clearAll,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.restart_alt_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text('전체해제',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('검색결과',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredPolices.isEmpty
                ? const Center(
                    child: Text('검색 결과가 없습니다...'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _filteredPolices.length,
                    itemBuilder: (BuildContext context, int index) {
                      final policy = _filteredPolices[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: ListTile(
                          title: Text(
                            policy.policyName ?? 'No name',
                            softWrap: true,
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            print('push');
                            // 여기에서 PostDetailScreen으로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PolicyDetailScreen(
                                  policyId: policy.policyId ?? 0,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _startListening() async {
    if (!_speech.isAvailable) {
      print('음성 입력 사용 불가능');
      return;
    }

    if (!_speech.isListening) {
      try {
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      } catch (e) {
        print('음성 입력 시작 중 오류 발생: $e');
      }
    } else {
      print('이미 음성 입력 중입니다.');
    }
  }

  void removeFilter(CategoryList filterToRemove) async {
    final prefs = await SharedPreferences.getInstance();

    // 'selectedFilters'에서 제거
    String selectedFiltersString = prefs.getString('selectedFilters') ?? '[]';
    List<dynamic> selectedFiltersJson = jsonDecode(selectedFiltersString);
    List<CategoryList> loadedSelectedFilters =
        selectedFiltersJson.map((e) => CategoryList.fromJson(e)).toList();

    loadedSelectedFilters.removeWhere((filter) =>
        filter.code == filterToRemove.code &&
        filter.number == filterToRemove.number);

    // 'filters'에서 제거
    String filtersString = prefs.getString('filters') ?? '[]';
    List<dynamic> filtersJson = jsonDecode(filtersString);
    filtersJson.removeWhere((filter) =>
        filter['code'] == filterToRemove.code &&
        filter['number'].toString() == filterToRemove.number);

    // SharedPreferences에 변경사항 저장
    await prefs.setString('selectedFilters',
        jsonEncode(loadedSelectedFilters.map((e) => e.toJson()).toList()));
    await prefs.setString('filters', jsonEncode(filtersJson));
    _searchListener();
    // 상태 업데이트
    setState(() {
      _selectedFilters = loadedSelectedFilters;
    });
    _fetchData(); // 필터를 제거한 후 검색 결과를 새로고침
    _searchListener(); // 검색 조건이 변경되었으므로 검색 리스너를 다시 호출
  }

  Future<void> _fetchAndUpdateData() async {
    // 이 메서드는 필터 업데이트 후 새로운 검색 결과를 불러오는 데 사용됩니다.
    _updateSearchConditions(); // 검색 조건을 업데이트하는 데 필요한 로직을 여기에 포함시키세요.
    _fetchData(); // 새로운 검색 결과를 불러옵니다.
  }

  void _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('filters');
    await prefs.remove('startDate');
    await prefs.remove('endDate');
    await prefs.remove('selectedFilters'); // 선택된 필터 목록도 초기화합니다.

    setState(() {
      _controller.text = '';
      _filteredPolices.clear();
      _selectedFilters.clear(); // 화면에서 선택된 필터 목록을 초기화합니다.
      _currentPage = 0;
      _hasMore = true;
    });

    await saveSelectedFilters(_selectedFilters); // 변경된 필터를 저장합니다.
    _searchListener(); // 모든 필터를 해제한 후 검색 결과를 초기화합니다.
  }

  void _updateFilters(List<CategoryList> returnedFilters) {
    setState(() {
      _selectedFilters.clear();
      _selectedFilters.addAll(returnedFilters);
    });
    Route createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FilterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    }

    _fetchData();
    _searchListener();
  }
}
