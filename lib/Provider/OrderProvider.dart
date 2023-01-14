import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditech_for_pharmacy/Provider/pharmacy_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../Models/Cart.dart';
import '../Models/Order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> orderList = [];
  bool isLoading = false;
  PharmacyProvider pharmacyProvider = PharmacyProvider();

  OrderProvider() {
    getOrders();
  }

  void getOrders() async {
    await pharmacyProvider.getCurrentUser();
    await getOrderList();
  }

  Future getOrderList() async {
    orderList.clear();
    isLoading = true;
    notifyListeners();

    // try {
    var data = await FirebaseFirestore.instance.collection('Orders').get();
    List<Order> tempList = [];

    tempList = List.from(data.docs.map((doc) => Order.fromSnapshot(doc)));

    List<Cart> tempCartList = [];
    int count = 0;
    for (var element in data.docs) {
      tempCartList = [];
      var tempData = element.data()['products'];
      for (int i = 0; i < tempData.length; i++) {
        tempCartList.add(Cart.fromMap(tempData['product$i']));
      }

      for (var element in tempCartList) {
        if (element.pharmacyId == FirebaseAuth.instance.currentUser!.uid) {
          tempList[count].cartList.add(element);
        }
      }
      orderList.add(tempList[count]);
      count++;
    }

    isLoading = false;
    notifyListeners();
  }

  completeOrder(Order order) async {
    isLoading = true;
    notifyListeners();
    Map<String, dynamic> data = {"isCompleted": true};
    await FirebaseFirestore.instance
        .collection("Orders")
        .doc(order.orderId)
        .update(data);
    orderList
        .firstWhere((element) => element.orderId == order.orderId)
        .isCompleted = true;
    isLoading = false;
    notifyListeners();
  }
}
