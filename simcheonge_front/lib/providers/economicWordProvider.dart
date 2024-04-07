import 'package:flutter/material.dart';
import 'package:simcheonge_front/services/e_word_api.dart';
import 'package:simcheonge_front/models/e_word_model.dart';

class EconomicWordProvider with ChangeNotifier {
  EWord? _economicWord;

  EWord? get economicWord => _economicWord;

  Future<void> fetchEconomicWord() async {
    final api = EWordAPI();
    _economicWord = await api.fetchEconomicWord();
    notifyListeners();
  }
}
