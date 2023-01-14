import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../Models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProductProvider with ChangeNotifier {
  bool isLoading = false;
  ProductProvider() {
    isLoading = false;
  }

  Future updateProduct(Product product, String previousImagePath) async {
    isLoading = true;
    notifyListeners();
    String url = "";
    if (!(previousImagePath == product.imagePath)) {
      firebase_storage.Reference photoRef = firebase_storage
          .FirebaseStorage.instance
          .refFromURL(previousImagePath);
      await photoRef.delete();

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              'productImages/${product.pharmacyId}/${product.imagePath.hashCode}');
      File file = File(product.imagePath);
      FirebaseFirestore db = FirebaseFirestore.instance;

      firebase_storage.UploadTask uploadTask = ref.putFile(file);

      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      url = await taskSnapshot.ref.getDownloadURL();
    }
    Map<String, dynamic> data = {
      "Name": product.name,
      "category": product.category,
      "sellPrice": product.sellPrice,
      "purchasePrice": product.purchasePrice,
      "description": product.description,
      "totalItems": product.totalItem,
      "expireDate": product.expireDate,
      "imageUrl":
          (previousImagePath == product.imagePath) ? product.imagePath : url,
      "pharmacyId": product.pharmacyId
    };
    await FirebaseFirestore.instance
        .collection('Pharmacies')
        .doc(product.pharmacyId)
        .collection('Products')
        .doc(product.id)
        .update(data);
    isLoading = false;
    notifyListeners();
  }

  Future addProduct(Product product) async {
    isLoading = true;
    notifyListeners();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'productImages/${product.pharmacyId}/${product.imagePath.hashCode}');
    File file = File(product.imagePath);
    FirebaseFirestore db = FirebaseFirestore.instance;

    firebase_storage.UploadTask uploadTask = ref.putFile(file);
    String url = "";

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    url = await taskSnapshot.ref.getDownloadURL();

    Map<String, dynamic> data = {
      "Name": product.name,
      "category": product.category,
      "sellPrice": product.sellPrice,
      "purchasePrice": product.purchasePrice,
      "description": product.description,
      "totalItems": product.totalItem,
      "expireDate": product.expireDate,
      "imageUrl": url,
      "pharmacyId": product.pharmacyId
    };
    await FirebaseFirestore.instance
        .collection("Pharmacies")
        .doc(product.pharmacyId)
        .collection("Products")
        .add(data);
    isLoading = false;
    notifyListeners();
  }

  Future deleteProduct(Product product) async {
    isLoading = true;
    notifyListeners();
    firebase_storage.Reference photoRef =
        firebase_storage.FirebaseStorage.instance.refFromURL(product.imagePath);

    await photoRef.delete();
    await FirebaseFirestore.instance
        .collection('Pharmacies/${product.pharmacyId}/Products')
        .doc(product.id)
        .delete();
    isLoading = false;
    notifyListeners();
  }
}
