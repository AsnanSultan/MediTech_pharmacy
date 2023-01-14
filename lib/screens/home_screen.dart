import 'package:flutter/material.dart';
import 'package:meditech_for_pharmacy/screens/chat_screen.dart';
import 'package:meditech_for_pharmacy/Widgets/bottom_bar.dart';
import 'package:meditech_for_pharmacy/screens/orders_screen.dart';
import 'package:meditech_for_pharmacy/screens/profile_screen.dart';
import 'package:meditech_for_pharmacy/screens/purchase_report_screen.dart';
import 'package:meditech_for_pharmacy/screens/sale_report_screen.dart';
import 'package:provider/provider.dart';

import '../Provider/pharmacy_provider.dart';
import '../Widgets/my_drawer.dart';
import 'add_product.dart';
import 'chat_screen.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    // getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: Drawer(
        child: MyDrawer(
          currentUser: pharmacyProvider.currentUser,
        ),
      ),
      bottomNavigationBar: const MyBottomBar(
        currentIndex: 0,
      ),
      body: pharmacyProvider.isLoading
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddProductScreen(
                                        currentUser:
                                            pharmacyProvider.currentUser,
                                      )));
                        },
                        child: ScaleTransition(
                          scale: _animation,
                          child: MyHomeIconBox(
                              "assets/icons/addProductIcon.png",
                              "Add Product",
                              const Color(0xFFa4adfc)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrdersScreen()),
                          );
                        },
                        child: ScaleTransition(
                          scale: _animation,
                          child: MyHomeIconBox("assets/icons/budget.png",
                              "Manage Orders", const Color(0xFFd6a4fc)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SaleReportScreen()));
                        },
                        child: ScaleTransition(
                          scale: _animation,
                          child: MyHomeIconBox("assets/icons/growth.png",
                              "Sale Report", const Color(0xFFd48ed4)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PurchaseReportScreen()));
                        },
                        child: ScaleTransition(
                          scale: _animation,
                          child: MyHomeIconBox("assets/icons/box.png",
                              "Purchase Report", const Color(0xFFc7ffed)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Chat()));
                        },
                        child: ScaleTransition(
                          scale: _animation,
                          child: MyHomeIconBox("assets/icons/chatbot.png",
                              "Need Help", const Color(0xFFfff7c2)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyProfileScreen()),
                              (route) => false);
                        },
                        child: ScaleTransition(
                          scale: _animation,
                          child: MyHomeIconBox("assets/icons/settings.png",
                              "Settings", const Color(0xFFffccc2)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

Widget MyHomeIconBox(String icon, String text, Color color) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 30, bottom: 10),
        height: 110,
        width: 120,
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          icon,
          fit: BoxFit.contain,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)),
          boxShadow: const [
            BoxShadow(color: Colors.black, spreadRadius: 2),
          ],
        ),
      ),
      Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ],
  );
}
