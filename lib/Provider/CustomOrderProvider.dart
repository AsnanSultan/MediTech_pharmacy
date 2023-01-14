import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/CustomOrder.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CustomOrderProvider with ChangeNotifier {
  bool isLoading = false;
  List<CustomOrder> customOrderList = [];

  Future<List<CustomOrder>> getCustomOrdersList() async {
    customOrderList.clear();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var data = await FirebaseFirestore.instance
          .collection('CustomOrder')
          // .where('status', isEqualTo: 'Requested')
          //.where('pharmacyId', isEqualTo: user!.uid)
          .get();
      List<CustomOrder> tempList = [];

      tempList =
          List.from(data.docs.map((doc) => CustomOrder.fromSnapshot(doc)));

      customOrderList.addAll(tempList);
      return customOrderList;
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Something wrong please check your internet connection", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1 // duration
          );
      return customOrderList;
    }
  }

  Future acceptRequest(CustomOrder customOrder) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> data = {"status": "Accepted"};
    await FirebaseFirestore.instance
        .collection("CustomOrder")
        .doc(customOrder.id)
        .update(data);
    isLoading = false;
    notifyListeners();
  }
}
