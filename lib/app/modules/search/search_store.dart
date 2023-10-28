import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/ads_model.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';

import '../../shared/utilities.dart';

part 'search_store.g.dart';

class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store implements Disposable {
  final MainStore mainStore = Modular.get();

  _SearchStoreBase() {
    getHistory();
  }

  @override
  void dispose() {
    textEditingController.dispose();
  }

  @observable
  String searchText = "";
  @observable
  String searchedText = "";
  @observable
  List? history;
  @observable
  List<Ads>? searchedItems;
  @observable
  TextEditingController textEditingController = TextEditingController();

  @action
  Future<void> getHistory() async {
    if(kIsWeb){
      history = [];
    } else {
      try {
        history = json.decode(
            await ((await getFile("history.json")).readAsString()))["history"];
      } on FileSystemException catch (e) {
        if (e.osError != null &&
            e.osError!.message == "No such file or directory") {
          await (await getFile("history.json")).writeAsString(jsonEncode({"history": []}));
          history = [];
        }
      }
    }
  }

  @action
  searching(String _searchText) async {
    if(!kIsWeb){
      searchedText = "";
      if (searchText == "") {
        searchedItems = null;
        searchedText = "";
      }
      searchText = _searchText;
      history = null;
      List _history = json.decode(
          await (await getFile("history.json")).readAsString())["history"];
      List _newHistory = [];
      for (int i = 0; i < _history.length; i++) {
        String label = _history[i]["label"];
        if (label.toLowerCase().contains(searchText.toLowerCase())) {
          _newHistory.add(_history[i]);
        }
      }
      history = _newHistory;
    } else {
      searchText = _searchText;
    }
  }

  @action
  Future<void> confirmSearch() async {
    if(kIsWeb){
      await getSearchedItems();
    } else {
      if (searchText == "") return;
      File _historyFile = await getFile("history.json");
      Map _historyJson = jsonDecode(await _historyFile.readAsString());
      List _historyList = _historyJson["history"];
      if (!_historyList.contains(searchText)) {
        _historyList.insert(0, {"label": searchText});
      }
      await getSearchedItems();
      history = _historyList;
      _historyJson["history"] = _historyList;
      await _historyFile.writeAsString(jsonEncode(_historyJson));
    }
  }

  @action
  Future<void> getSearchedItems() async {
    searchedText = searchText;
    searchText = "";

    QuerySnapshot adsQue = await FirebaseFirestore.instance
      .collection("ads")
      .where("status", isEqualTo: "ACTIVE")
      .where("online_seller", isEqualTo: true)
      .where("paused", isEqualTo: false)
      .orderBy("highlighted", descending: true)
      .get();

    List<Ads> _searchedItems = [];

    for (int i = 0; i < adsQue.docs.length; i++) {
      DocumentSnapshot doc = adsQue.docs[i];

      String category = doc["category"].toLowerCase();

      String type = doc["type"].toLowerCase();

      String title = doc["title"].toLowerCase();

      String description = doc["description"].toLowerCase();

      String text = searchedText.toLowerCase();

      if (category.contains(text) ||
          type.contains(text) ||
          title.contains(text) ||
          description.contains(text)) {
        _searchedItems.add(Ads.fromDoc(doc));
      }
    }
    searchedItems = _searchedItems;
  }

  @action
  removeRecentSearch(String label) async {
    File historyFile = await getFile("history.json");
    Map historyData = jsonDecode(await historyFile.readAsString());
    List _history = historyData["history"];
    _history.removeWhere((search) => search["label"] == label);
    historyData["history"] = _history;
    historyFile.writeAsString(jsonEncode(historyData));
    history = _history;
  }

  @action
  cleanHistory() async {
    Directory dir = await getApplicationDocumentsDirectory();
    File historyFile = File("${dir.path}/history.json");
    Map historyData = jsonDecode(await historyFile.readAsString());
    historyData["history"] = [];
    await historyFile.writeAsString(jsonEncode(historyData));
    history = [];
  }
}
