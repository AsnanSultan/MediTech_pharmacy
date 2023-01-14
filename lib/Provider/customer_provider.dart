import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../Models/Customer.dart';

class CustomerProvider with ChangeNotifier {
  bool isLoading = false;
  CustomerProvider();

  Future<Customer> getCustomer(String id) async {
    var data =
        await FirebaseFirestore.instance.collection("Customers").doc(id).get();
    return Customer.fromSnapshot(data);
  }
}
