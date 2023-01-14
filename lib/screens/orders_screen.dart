import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Provider/OrderProvider.dart';
import 'order_detail.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: orderProvider.isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            )
          : StreamBuilder<QuerySnapshot>(builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              return ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: orderProvider.orderList.length,
                  itemBuilder: (context, index) {
                    String orderStatus = "";
                    orderStatus = orderProvider.orderList[index].isCompleted
                        ? "Completed"
                        : "inProcess";
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(8),
                      shadowColor: Colors.blueAccent,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailScreen(
                                        order: orderProvider.orderList[index],
                                      )));
                        },
                        leading: Image.asset('assets/images/orderMedicine.png'),
                        title: Row(
                          children: [
                            const Text('Order#'),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: Text(
                                orderProvider.orderList[index].orderId,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.blue,
                                    fontSize: 22),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                            'Date: ${orderProvider.orderList[index].dateTime}'),
                        trailing: Text(
                          orderStatus,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: orderStatus == "Completed"
                                  ? Colors.green
                                  : Colors.blue),
                        ),
                      ),
                    );
                  });
            }),
    );
  }
}
