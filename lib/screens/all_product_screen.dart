import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:meditech_for_pharmacy/Provider/pharmacy_provider.dart';
import 'package:meditech_for_pharmacy/Widgets/bottom_bar.dart';
import 'package:meditech_for_pharmacy/screens/add_product.dart';
import 'package:provider/provider.dart';

import '../Models/Pharmacy.dart';
import '../Provider/product_provider.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  bool flag = false;
  void _onLoading() {
    flag = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            width: 200,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  Text("Loading..."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    pharmacyProvider.getProductList();
    Pharmacy tempPhar = pharmacyProvider.pharmacyList.firstWhere(
        (pharmacy) => pharmacyProvider.currentUser.id == pharmacy.id);
    if (flag && productProvider.isLoading != true) {
      Navigator.pop(context);
      flag = false;
      setState(() {});
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      bottomNavigationBar: const MyBottomBar(
        currentIndex: 1,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: AnimationLimiter(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 100.0,
                  horizontalOffset: 100,
                  delay: const Duration(milliseconds: 200),
                  child: FadeInAnimation(
                    child: Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 80,
                                height: 100,
                                child: Image.network(
                                  tempPhar.products[index].imagePath,
                                  fit: BoxFit.cover,
                                )),
                            Container(
                              margin: const EdgeInsets.only(left: 12, right: 12),
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tempPhar.products[index].name,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    'Price: ${tempPhar.products[index].sellPrice} pkr',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 230,
                                    child: Text(
                                      'Category: ${tempPhar.products[index].category} pkr',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Expire date: ${tempPhar.products[index].expireDate}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddProductScreen(
                                                    currentUser:
                                                        pharmacyProvider
                                                            .currentUser,
                                                    product: tempPhar
                                                        .products[index],
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    )),
                                const SizedBox(
                                  width: 1,
                                  height: 30,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      productProvider
                                          .deleteProduct(
                                              tempPhar.products[index])
                                          .whenComplete(() => pharmacyProvider
                                              .getProductList());

                                      _onLoading();
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: tempPhar.products.length,
          ),
        ),
      ),
    );
  }
}
