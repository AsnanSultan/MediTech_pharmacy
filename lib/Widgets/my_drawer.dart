import 'package:flutter/material.dart';
import 'package:meditech_for_pharmacy/Models/Pharmacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditech_for_pharmacy/screens/orders_screen.dart';
import '../RegistrationScreens/signin_page.dart';
import '../screens/CustomOrder/custom_order_screen.dart';
import '../screens/Return/Exchange/exchangeProductScreen.dart';
import '../screens/Settings/rate_us.dart';
import '../screens/chat_screen.dart';
import 'my_setting_row.dart';
import 'package:flutter_share/flutter_share.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({required this.currentUser, Key? key}) : super(key: key);

  Pharmacy currentUser;
  Future<void> share() async {
    await FlutterShare.share(
      title: 'Medi-Tech App',
      text: 'Medi-Tech App',
      linkUrl: 'Application link will be added latter',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color(0xff00C0FF),
            padding: const EdgeInsets.only(
                top: 60.0, left: 2, right: 12, bottom: 30),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                    "assets/icons/pharmacy.png",
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160,
                      child: Text(
                        currentUser.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(currentUser.phone),
                    SizedBox(
                      width: 145,
                      child: Text(
                        currentUser.email,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                    child: SizedBox(
                  height: 1,
                )),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.black,
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                MySettingRow(Icons.shopping_cart, "Orders", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrdersScreen()));
                }),
                MySettingRow(Icons.dashboard_customize, "Custom Orders", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomOrderScreen()));
                }),
                MySettingRow(Icons.repeat, "Return/Exchange", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ExchangeProductsScreen()));
                }),
                // MySettingRow(Icons.account_balance_wallet, "Payments", () {}),
                MySettingRow(
                  Icons.headset_mic_rounded,
                  "Need Help",
                  () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Chat()));
                  },
                ),
                MySettingRow(Icons.share, "Share App", () {
                  share();
                }),
                MySettingRow(Icons.star_rate, "Rate Us", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RateUsScreen()));
                }),
                MySettingRow(Icons.logout, "Logout", () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                      (route) => false);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
