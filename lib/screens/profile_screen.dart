import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:meditech_for_pharmacy/screens/chat_screen.dart';
import 'package:meditech_for_pharmacy/screens/orders_screen.dart';

import 'package:provider/provider.dart';
import '../Provider/pharmacy_provider.dart';
import '../RegistrationScreens/signin_page.dart';
import '../Widgets/bottom_bar.dart';
import '../Widgets/my_setting_row.dart';
import 'Settings/rate_us.dart';
import 'package:flutter_share/flutter_share.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Future<void> share() async {
    await FlutterShare.share(
      title: 'Medi-Tech App',
      text: 'Medi-Tech App',
      linkUrl: 'Application link will be added latter',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    //getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      bottomNavigationBar: const MyBottomBar(currentIndex: 3),
      body: pharmacyProvider.isLoading
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(
                    /* height: MediaQuery.of(context).size.height-162,
              width: MediaQuery.of(context).size.width,*/
                    color: const Color(0xffFFFFFF),
                    padding: const EdgeInsets.all(12.0),
                    child: AnimationLimiter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 400.0,
                            verticalOffset: -200,
                            delay: const Duration(milliseconds: 120),
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.blue,
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
                                    Text(
                                      pharmacyProvider.currentUser.name,
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(pharmacyProvider.currentUser.phone),
                                    Text(pharmacyProvider.currentUser.email),
                                  ],
                                ),
                                const Expanded(
                                    child: SizedBox(
                                  height: 1,
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 1,
                              color: Colors.black,
                            ),

                            // MySettingRow(Icons.settings, "General Settings"),

                            MySettingRow(Icons.shopping_cart, "Orders", () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrdersScreen()));
                            }),
                            /*    MySettingRow(Icons.account_balance_wallet,
                                "Payments", () {}),*/
                            MySettingRow(Icons.headset_mic_rounded, "Need Help",
                                () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Chat()));
                            }),

                            MySettingRow(Icons.share, "Share App", () {
                              share();
                            }),
                            MySettingRow(Icons.star_rate, "Rate Us", () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RateUsScreen()));
                            }),
                            MySettingRow(Icons.logout, "Logout", () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInPage()),
                                  (route) => false);
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
