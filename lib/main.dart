import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:meditech_for_pharmacy/Provider/customer_provider.dart';
import 'package:meditech_for_pharmacy/Provider/pharmacy_provider.dart';
import 'package:meditech_for_pharmacy/Provider/product_provider.dart';

import 'package:meditech_for_pharmacy/screens/splash_screen.dart';
import 'Provider/CustomOrderProvider.dart';
import 'Provider/OrderProvider.dart';
import 'Provider/exchangeProvider.dart';
import 'constants.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PharmacyProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(
          create: (context) => ExchangeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomOrderProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediTech for Pharmacy',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          scaffoldBackgroundColor: kBackgroundColor,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MySplashScreen(),
      ),
    );
  }
}
