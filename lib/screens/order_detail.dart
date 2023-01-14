import 'package:flutter/material.dart';
import 'package:meditech_for_pharmacy/Provider/OrderProvider.dart';
import 'package:meditech_for_pharmacy/Provider/customer_provider.dart';
import 'package:provider/provider.dart';

import '../Models/Customer.dart';
import '../Models/Order.dart';
import '../Models/Product.dart';
import '../Provider/pharmacy_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({required this.order, Key? key}) : super(key: key);
  Order order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Customer customer = Customer(
      id: "id", name: "name", email: "email", phone: "phone", lat: 0, lng: 0);

  searchCustomer(CustomerProvider customerProvider, String id) async {
    customer = await customerProvider.getCustomer(id);
    setState(() {});
  }

  bool isCalled = false;
  double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
    // totalPrice = 0;
    String orderStatus = "";
    if (!isCalled) {
      searchCustomer(customerProvider, widget.order.userId);
      isCalled = true;
    }
    orderStatus = widget.order.isCompleted ? "Completed" : "inProcess";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order No.  ${widget.order.orderId}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(
              'Total Products  ${widget.order.cartList.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
              children: [
                const Text('Status: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  orderStatus,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: orderStatus == "Completed"
                          ? Colors.green
                          : Colors.blue),
                ),
                const Spacer(),
                if (orderStatus != "Completed")
                  GestureDetector(
                    onTap: () {
                      Widget okButton = TextButton(
                        child: const Text("Yes"),
                        onPressed: () async {
                          await Provider.of<OrderProvider>(context,
                                  listen: false)
                              .completeOrder(widget.order);
                          Navigator.pop(context);
                          setState(() {});
                          Navigator.pop(context);
                        },
                      );

                      AlertDialog alert = AlertDialog(
                        title: const Text("Alert"),
                        content:
                            const Text("Are you sure to complete this Order"),
                        actions: [
                          okButton,
                        ],
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 90,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.blueAccent,
                      ),
                      child: const Center(
                        child: Text(
                          "Complete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: widget.order.cartList.length,
                  itemBuilder: (context, index) {
                    Product tempProduct = pharmacyProvider.getProductFromId(
                        widget.order.cartList[index].productId);

                    totalPrice += tempProduct.sellPrice *
                        widget.order.cartList[index].count;
                    return Card(
                        child: ListTile(
                      leading: Image.network(
                        tempProduct.imagePath,
                        height: 55,
                        width: 55,
                      ),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer:  ${customer.name}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Product:  ${tempProduct.name}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ]),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Items: ${widget.order.cartList[index].count}'),
                          Text(
                              'Price: ${tempProduct.sellPrice * widget.order.cartList[index].count}'),
                        ],
                      ),
                    ));
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  "${totalPrice}PKr",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
