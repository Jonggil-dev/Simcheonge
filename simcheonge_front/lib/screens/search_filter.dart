import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simcheonge_front/models/filter_model.dart';
import 'package:simcheonge_front/services/filter_api.dart';

enum DateSelection { always, undecided, selectPeriod }

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  Map<String, bool> regionSelections = {};
  Map<String, bool> educationSelections = {};
  Map<String, bool> employmentStatusSelections = {};
  Map<String, bool> specializationSelections = {};
  Map<String, bool> interestSelections = {};
  Map<String, bool> periodSelections = {};
  Map<String, List<CategoryList>> fullCategoryLists = {};
  DateTime? startDate;
  DateTime? endDate;

  DateTime? tempStartDate;
  DateTime? tempEndDate;

  DateSelection dateSelection = DateSelection.always;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> filtersList = [];
  List<String> regionOptions = [];
  List<String> educationOptions = [];
  List<String> employmentStatusOptions = [];
  List<String> specializationOptions = [];
  List<String> interestOptions = [];
  List<String> periodOptions = [];

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
  }

  Future<void> _loadFilterOptions() async {
    try {
      final filterModel = await FilterApi.fetchFilters();
      setState(() {
        regionOptions = _extractNames(filterModel, 'RGO');
        educationOptions = _extractNames(filterModel, 'ADM');
        employmentStatusOptions = _extractNames(filterModel, 'EPM');
        specializationOptions = _extractNames(filterModel, 'SPC');
        interestOptions = _extractNames(filterModel, 'PFD');
        periodOptions = _extractNames(filterModel, 'APC');
        regionSelections = _initializeSelections(regionOptions);
        educationSelections = _initializeSelections(educationOptions);
        employmentStatusSelections =
            _initializeSelections(employmentStatusOptions);
        specializationSelections = _initializeSelections(specializationOptions);
        interestSelections = _initializeSelections(interestOptions);
        periodSelections = _initializeSelections(periodOptions);
        fullCategoryLists = {
          for (var item in filterModel.data ?? [])
            item.tag: item.categoryList ?? []
        };
      });
    } catch (e) {
      debugPrint("Failed to load filter options: $e");
    }
  }

  List<String> _extractNames(FilterModel filterModel, String tag) {
    return filterModel.data
            ?.firstWhere((d) => d.tag == tag, orElse: () => Data())
            .categoryList
            ?.map((e) => e.name ?? '')
            .toList() ??
        [];
  }

  Map<String, bool> _initializeSelections(List<String> options) {
    return {for (var option in options) option: false};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('필터'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildToggleButtons('지역', regionOptions, regionSelections),
            _buildToggleButtons('학력', educationOptions, educationSelections),
            _buildToggleButtons(
                '취업 상태', employmentStatusOptions, employmentStatusSelections),
            _buildToggleButtons(
                '특화 분야', specializationOptions, specializationSelections),
            _buildToggleButtons('관심 분야', interestOptions, interestSelections),
            _buildToggleButtons('신청 기간', periodOptions, periodSelections),
            buildDateSelectionContent(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.replay_outlined),
                  label: const Text('초기화'),
                  onPressed: _filtersSelected() ? _resetFilters : null,
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveFilters,
                  child: const Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateSelectionContent() {
    if (dateSelection != DateSelection.selectPeriod ||
        startDate == null ||
        endDate == null ||
        !(periodSelections['기간 선택'] ?? false)) {
      return Container(); // 선택한 날짜 범위가 없으면 아무것도 표시하지 않음
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedStartDate = formatter.format(startDate!);
    final String formattedEndDate = formatter.format(endDate!);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '선택 기간: $formattedStartDate ~ $formattedEndDate',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildDateSelection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToggleButtons(
            borderRadius: BorderRadius.circular(8),
            isSelected: [
              dateSelection == DateSelection.always,
              dateSelection == DateSelection.undecided,
              dateSelection == DateSelection.selectPeriod,
            ],
            onPressed: (int index) {
              setState(() {
                dateSelection = DateSelection.values[index];
                if (dateSelection == DateSelection.selectPeriod) {
                  _showDateRangePickerModal();
                } else {
                  // 기간 선택이 아닌 다른 옵션을 선택했을 때 tempStartDate와 tempEndDate를 null로 설정
                  tempStartDate = null;
                  tempEndDate = null;
                }
              });
            },
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('상시'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('미정'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('기간 선택'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons(
      String title, List<String> options, Map<String, bool> selections) {
    bool isSingleChoice = title == '신청 기간';
    bool isFirstOptionExclusive =
        title == '학력' || title == '취업 상태' || title == '특화 분야';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Wrap(
            spacing: 8.0,
            children: List<Widget>.generate(options.length, (index) {
              return ChoiceChip(
                showCheckmark: false,
                label: Text(options[index]),
                selected: selections[options[index]] ?? false,
                onSelected: (bool selected) {
                  setState(() {
                    if (isSingleChoice ||
                        (isFirstOptionExclusive && index == 0)) {
                      // 모든 선택 해제 후 현재 선택만 활성화
                      selections.forEach((key, _) => selections[key] = false);
                      selections[options[index]] = selected;
                    } else if (isFirstOptionExclusive) {
                      // 첫 번째 항목이 이미 선택된 상태에서 다른 항목을 선택하면 첫 번째 항목 해제
                      if (selections[options[0]] == true) {
                        selections[options[0]] = false;
                      }
                      selections[options[index]] = selected;
                    } else {
                      selections[options[index]] = selected;
                    }

                    // '신청 기간' 선택이고, 3번째 항목('기간 선택')이 선택된 경우 날짜 선택기를 실행합니다.
                    if (title == '신청 기간' && index == 2 && selected) {
                      _showDateRangePickerModal();
                    }
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDateRangePickerModal() {
    DateSelection tempDateSelection = dateSelection;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("기간 선택"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: tempStartDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                        helpText: "시작 날짜 선택",
                      );
                      if (picked != null) {
                        setState(() {
                          tempStartDate = picked;
                          if (tempEndDate != null &&
                              tempEndDate!.isBefore(picked)) {
                            tempEndDate = picked;
                          }
                        });
                      }
                    },
                    child: Text(tempStartDate == null
                        ? "시작 날짜 선택"
                        : "시작 날짜: ${DateFormat('yyyy-MM-dd').format(tempStartDate!)}"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: tempEndDate ??
                            (tempStartDate ?? DateTime.now())
                                .add(const Duration(days: 1)),
                        firstDate: tempStartDate ?? DateTime.now(),
                        lastDate: DateTime(2025),
                        helpText: "종료 날짜 선택",
                      );
                      if (picked != null) {
                        setState(() {
                          tempEndDate = picked;
                        });
                      }
                    },
                    child: Text(tempEndDate == null
                        ? "종료 날짜 선택"
                        : "종료 날짜: ${DateFormat('yyyy-MM-dd').format(tempEndDate!)}"),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop();

                    if (mounted) {
                      setState(() {
                        periodSelections = {};
                        tempStartDate = null;
                        tempEndDate = null;
                      });
                    }
                  },
                ),
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    if (tempStartDate != null && tempEndDate != null) {
                      setState(() {
                        // 확인 버튼을 눌렀을 때 선택한 날짜를 실제 변수에 할당하고 선택 기간을 표시
                        startDate = tempStartDate;
                        endDate = tempEndDate;
                        dateSelection = DateSelection.selectPeriod;
                        // 변경사항 즉시 적용
                        tempStartDate = startDate;
                        tempEndDate = endDate;
                      });
                      Navigator.of(context).pop(); // 모달 닫기
                      _scrollToDateSelectionContent();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Dialog가 닫히면 (확인 또는 밖을 눌러서)
      // 사용자가 날짜를 선택하지 않고 닫았다면, 기간 선택이 취소된 것으로 간주하고 초기 상태로 복원합니다.
      if (mounted) {
        setState(() {
          if (startDate == null || endDate == null) {
            dateSelection = tempDateSelection; // 사용자가 날짜를 선택하지 않았다면 원래의 상태로 복원
          }
        });
      }
    });
  }

  bool _filtersSelected() {
    return regionSelections.containsValue(true) ||
        educationSelections.containsValue(true) ||
        employmentStatusSelections.containsValue(true) ||
        specializationSelections.containsValue(true) ||
        interestSelections.containsValue(true) ||
        periodSelections.containsValue(true);
  }

  void _scrollToDateSelectionContent() {
    // buildDateSelectionContent가 화면에 표시된 후에 호출되어야 합니다.
    // 따라서, postFrameCallback을 사용하여 위젯 트리가 완전히 빌드된 후에 스크롤 조정이 이루어지도록 합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // 스크롤 컨트롤러를 사용하여 원하는 위치로 스크롤합니다.
        // 예: 스크롤 컨트롤러의 최대 스크롤 가능 위치로 이동
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _resetFilters() {
    setState(() {
      regionSelections.forEach((key, value) => regionSelections[key] = false);
      educationSelections
          .forEach((key, value) => educationSelections[key] = false);
      employmentStatusSelections
          .forEach((key, value) => employmentStatusSelections[key] = false);
      specializationSelections
          .forEach((key, value) => specializationSelections[key] = false);
      interestSelections
          .forEach((key, value) => interestSelections[key] = false);
      periodSelections.forEach((key, value) => periodSelections[key] = false);
      regionSelections = _initializeSelections(regionOptions);
      educationSelections = _initializeSelections(educationOptions);
      employmentStatusSelections =
          _initializeSelections(employmentStatusOptions);
      specializationSelections = _initializeSelections(specializationOptions);
      interestSelections = _initializeSelections(interestOptions);
      periodSelections = _initializeSelections(periodOptions);
      dateSelection = DateSelection.always;
      tempStartDate = null;
      tempEndDate = null;
    });
  }

  Future<void> _saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> filtersList = [];
    bool isAPCSelectedForPeriod = false;

    void addToFiltersList(Map<String, bool> selections, String tag) {
      final categoryList = fullCategoryLists[tag] ?? [];
      for (var category in categoryList) {
        if (selections[category.name] == true) {
          // 여기에 name도 추가
          filtersList.add({
            "code": tag,
            "number": category.code,
            "name": category.name, // 이름을 추가
          });
          if (tag == "APC" && category.code == "3") {
            isAPCSelectedForPeriod = true;
          }
        }
      }
    }

    // 각 선택 항목에 대해 addToFiltersList 함수를 호출
    addToFiltersList(regionSelections, "RGO");
    addToFiltersList(educationSelections, "ADM");
    addToFiltersList(employmentStatusSelections, "EPM");
    addToFiltersList(specializationSelections, "SPC");
    addToFiltersList(interestSelections, "PFD");
    addToFiltersList(periodSelections, "APC");

    // APC가 3으로 선택되었고, startDate와 endDate가 유효한 경우에만 추가
    if (isAPCSelectedForPeriod && startDate != null && endDate != null) {
      prefs.setString('startDate', DateFormat("yyyy-MM-dd").format(startDate!));
      prefs.setString('endDate', DateFormat("yyyy-MM-dd").format(endDate!));
    }

    // 필터 목록을 SharedPreferences에 저장합니다.
    await prefs.setString('filters', jsonEncode(filtersList));

    // 선택된 필터들을 저장합니다. 각 선택된 항목을 CategoryList 객체의 리스트로 변환하여 저장합니다.
    List<CategoryList> selectedFilters = [];
    for (var selection in [
      regionSelections,
      educationSelections,
      employmentStatusSelections,
      specializationSelections,
      interestSelections,
      periodSelections,
    ]) {
      selection.forEach((key, value) {
        if (value) {
          // 선택된 경우
          var category = fullCategoryLists.entries
              .firstWhere(
                  (element) => element.value.any((item) => item.name == key),
                  orElse: () => const MapEntry("", []))
              .value
              .firstWhere((item) => item.name == key,
                  orElse: () => CategoryList());
          selectedFilters
              .add(CategoryList(code: category.code, name: category.name));
        }
      });
    }

    // JSON 문자열로 변환하여 저장
    String encodedSelectedFilters =
        jsonEncode(selectedFilters.map((filter) => filter.toJson()).toList());
    await prefs.setString('selectedFilters', encodedSelectedFilters);

    // Navigator.pop을 호출할 때는 List<CategoryList> 타입으로 반환합니다.
    Navigator.pop(context, selectedFilters);
  }
}
