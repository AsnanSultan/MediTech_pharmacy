import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditech_for_pharmacy/Provider/exchangeProvider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Models/Cart.dart';
import '../../../Models/Customer.dart';
import '../../../Models/Exchange.dart';
import '../../../Models/Pharmacy.dart';
import '../../../Models/Product.dart';
import '../../../Provider/customer_provider.dart';
import '../../../Provider/pharmacy_provider.dart';
import '../../../Widgets/my_text_button.dart';
import '../../../constants.dart';

class ReturnExchangeScreen extends StatefulWidget {
  ReturnExchangeScreen({required this.returnProduct, Key? key})
      : super(key: key);

  Exchange returnProduct;
  @override
  State<ReturnExchangeScreen> createState() => _ReturnExchangeScreenState();
}

class _ReturnExchangeScreenState extends State<ReturnExchangeScreen> {
  TextEditingController details = TextEditingController();
  String customerId = "";
  Customer? tempCustomer;
  var isLoading = false;
  getCustomer(CustomerProvider customerProvider) async {
    isLoading = true;
    setState(() {});
    print(widget.returnProduct.customerId);
    tempCustomer =
        await customerProvider.getCustomer(widget.returnProduct.customerId);
    isLoading = false;
    setState(() {});
  }

  bool isCalled = false;

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    ExchangeProvider exchangeProvider = Provider.of<ExchangeProvider>(context);
    if (!isCalled) {
      details.text = widget.returnProduct.reason;
      getCustomer(customerProvider);
      isCalled = true;
    }

    Product tempProduct =
        pharmacyProvider.getProductFromId(widget.returnProduct.productId);
    Pharmacy tempPharmacy = pharmacyProvider.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Return/Exchange"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product Info",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      child: Row(
                        children: [
                          Image.network(
                            tempProduct.imagePath,
                            width: 90,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Product Name: ${tempProduct.name}'),
                              Text(
                                  'Total Items: ${widget.returnProduct.count}'),
                              Text('Product Price: ${tempProduct.sellPrice}'),
                              Text('Category: ${tempProduct.category}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Customer Info",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 5),
                            child: Image.asset(
                              'assets/images/UserIcon.png',
                              width: 80,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${tempCustomer!.name}'),
                              Text('Number: ${tempCustomer!.phone}'),
                              Text('Email : ${tempCustomer!.email}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        controller: details,
                        onChanged: (val) {
                          // purchasePrice = double.parse(val);
                        },
                        style: kBodyText.copyWith(color: Colors.blue),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        readOnly: true,
                        //textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "Reason",
                          contentPadding: const EdgeInsets.all(20),
                          hintStyle: TextStyle(fontSize: 12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Receipt: ",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 200,
                      width: 180,
                      margin: EdgeInsets.only(left: 80),
                      child: Image.network(
                        '${widget.returnProduct.receipt}',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text('${widget.returnProduct.status}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Price",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            '${tempProduct.sellPrice * widget.returnProduct.count}Pkr',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (widget.returnProduct.status == 'inProcess')
                      MyTextButton(
                          buttonName: 'Accept this Return/Exchange Request',
                          onTap: () async {
                            await exchangeProvider
                                .acceptRequest(widget.returnProduct)
                                .then((value) {
                              widget.returnProduct.status = "Accepted";
                              Fluttertoast.showToast(
                                  msg:
                                      "Return/Exchange Request Accepted", // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.white,
                                  backgroundColor:
                                      Colors.blueAccent, //  // location
                                  timeInSecForIosWeb: 1 // duration
                                  );
                            });
                            setState(() {});
                          },
                          bgColor: Colors.blueAccent,
                          textColor: Colors.white,
                          isLoading: exchangeProvider.isLoading),
                  ],
                ),
              ),
            ),
    );
  }
}
