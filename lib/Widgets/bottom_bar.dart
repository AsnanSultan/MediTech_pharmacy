import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditech_for_pharmacy/screens/all_product_screen.dart';
import '../screens/Settings/notification.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class MyBottomBar extends StatelessWidget {
  final int currentIndex;
  const MyBottomBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(top: 8),
      //margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: ClipRRect(
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.house_alt,
              ),
              label: "Home",
              tooltip: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt,
              ),
              label: "Products",
              tooltip: "Products",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
              ),
              label: "Notification",
              tooltip: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: "Profile",
              tooltip: "Profile",
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomeScreen()),
                  (route) => false);
            }
            if (index == 1) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AllProductScreen()),
                  (route) => false);
            }
            if (index == 2) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                  (route) => false);
            }
            if (index == 3) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfileScreen()),
                  (route) => false);
            }
          },
        ),
      ),
    );
  }
}
