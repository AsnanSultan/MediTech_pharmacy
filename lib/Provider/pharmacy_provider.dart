import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Pharmacy.dart';
import '../Models/Product.dart';

class PharmacyProvider with ChangeNotifier {
  late Pharmacy currentUser;
  List<Pharmacy> pharmacyList = [];
  List<Product> productList = [];
  bool isLoading = false;

  PharmacyProvider() {
    currentUser = Pharmacy("", "", "", "", 0.0, 0.0);
    getCurrentUser();
    getData();
  }
  Future getUser(User user) async {
    var data = await FirebaseFirestore.instance
        .collection("Pharmacies")
        .doc(user.uid)
        .get();
    currentUser = Pharmacy.fromSnapshot(data);
  }

  Future<bool> getCurrentUser() async {
    bool flag = false;
    isLoading = false;
    notifyListeners();
    await Firebase.initializeApp().whenComplete(() {
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user != null) {
          await getUser(user);
          flag = true;
        }
      });
    });
    isLoading = false;
    notifyListeners();
    return flag;
  }

  void getData() async {
    isLoading = true;
    notifyListeners();
    await getProductList();
    isLoading = false;
    notifyListeners();
  }

  Future getPharmacyList() async {
    try {
      var data =
          await FirebaseFirestore.instance.collection("Pharmacies").get();

      pharmacyList =
          List.from(data.docs.map((doc) => Pharmacy.fromSnapshot(doc)));
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Something wrong please check your internet connection", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1 // duration
          );
    }
  }

  Future getProductList() async {
    await getPharmacyList();
    productList.clear();
    String uid = '';
    for (int i = 0; i < pharmacyList.length; i++) {
      uid = pharmacyList[i].id;

      try {
        var data = await FirebaseFirestore.instance
            .collection('Pharmacies/$uid/Products')
            .get();
        List<Product> tempList = [];

        tempList = List.from(data.docs.map((doc) => Product.fromSnapshot(doc)));
        List<Product> tempProducts = [];
        tempProducts.addAll(
            tempList.where((element) => element.pharmacyId == currentUser.id));
        pharmacyList[i].products.addAll(tempProducts);
        productList.addAll(tempProducts);
      } catch (e) {
        Fluttertoast.showToast(
            msg:
                "Something wrong please check your internet connection", // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.CENTER, // location
            timeInSecForIosWeb: 1 // duration
            );
      }
    }
  }

  Product getProductFromId(String id) {
    return productList.firstWhere((element) => element.id == id);
  }
}
