import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simcheonge_front/providers/economicWordProvider.dart'; // 경로 확인 필요
import 'package:word_break_text/word_break_text.dart';

class EconomicWordWidget extends StatefulWidget {
  const EconomicWordWidget({super.key});

  @override
  _EconomicWordWidgetState createState() => _EconomicWordWidgetState();
}

class _EconomicWordWidgetState extends State<EconomicWordWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EconomicWordProvider>(context);
    final data = provider.economicWord?.data;

    final theme = Theme.of(context);
    final titleStyle =
        theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final contentStyle = theme.textTheme.bodyMedium;
    final maxHeight = MediaQuery.of(context).size.height * 0.35;

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Material(
          color: isExpanded
              ? const Color.fromRGBO(227, 241, 255, 1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                    isExpanded
                        ? Icons.tips_and_updates
                        : Icons.tips_and_updates_outlined,
                    color: const Color.fromARGB(246, 255, 246, 121)),
                title: Text(data?.word ?? '로딩 중...', style: titleStyle),
                trailing: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              if (isExpanded) const Divider(color: Colors.black, thickness: 1),
              AnimatedCrossFade(
                firstChild: const SizedBox(),
                secondChild: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: WordBreakText(
                          data?.description ?? '상세 설명을 불러오는 중...',
                          style: contentStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
