import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

import '../Models/Exchange.dart';

class ExchangeProvider with ChangeNotifier {
  bool isLoading = false;
  List<Exchange> exchangeList = [];
  ExchangeProvider() {
    getReturnExchangeList();
  }

  Future<List<Exchange>> getReturnExchangeList() async {
    exchangeList.clear();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var data = await FirebaseFirestore.instance
          .collection('Return_Exchange')
          .where('pharmacyId', isEqualTo: user!.uid)
          .get();
      List<Exchange> tempList = [];

      tempList = List.from(data.docs.map((doc) => Exchange.fromSnapshot(doc)));

      exchangeList.addAll(tempList);
      return exchangeList;
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Something wrong please check your internet connection", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1 // duration
          );
      return exchangeList;
    }
  }

  Future acceptRequest(Exchange exchangeProduct) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> data = {"status": "Accepted"};
    await FirebaseFirestore.instance
        .collection("Return_Exchange")
        .doc(exchangeProduct.id)
        .update(data);
    isLoading = false;
    notifyListeners();
  }
}
