import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meditech_for_pharmacy/RegistrationScreens/signin_page.dart';
import 'package:meditech_for_pharmacy/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/my_text_button.dart';
import '../constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;
  bool isLoading = false;
  String email = "", password = "", name = "", number = "", address = "";
  double mapHeight = 150.0, lat = 0.0, lng = 0.0;

  TextEditingController addressController = TextEditingController();

  final CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(31.5204, 74.3587), zoom: 15);

  late GoogleMapController _controller;
  final List<Marker> markers = <Marker>[
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(31.5204, 74.3587),
    )
  ];

  Future<void> createUser(var uid) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection("Pharmacies").doc(uid).set({
        "id": uid,
        "name": name,
        "email": email,
        "number": number,
        "lat": lat,
        "lng": lng
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something is wrong", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueAccent, // location
          timeInSecForIosWeb: 1 // duration
          );
    }
  }

  bool checkValues() {
    if (name == "" ||
        errorMessage != "" ||
        password.length < 4 ||
        number.length < 11 ||
        address == "") return false;
    return true;
  }

  void registerUser() async {
    isLoading = true;
    setState(() {});
    if (checkValues()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        createUser(userCredential.user?.uid).whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyHomeScreen()),
          );
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
              msg: "The password provided is too weak.", // message
              toastLength: Toast.LENGTH_SHORT, // length
              gravity: ToastGravity.CENTER, // location
              timeInSecForIosWeb: 1 // duration
              );
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: "The account already exists for that email.",
              // message
              toastLength: Toast.LENGTH_SHORT,
              // length
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueAccent,
              // location
              timeInSecForIosWeb: 1 // duration
              );
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Something is wrong",
            // message
            toastLength: Toast.LENGTH_SHORT,
            // length
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.blueAccent,
            // location
            timeInSecForIosWeb: 1 // duration
            );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please fill all the entries",
          // message
          toastLength: Toast.LENGTH_SHORT,
          // length
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueAccent,
          // location
          timeInSecForIosWeb: 1 // duration
          );
    }
    isLoading = false;
    setState(() {});
  }

  String errorMessage = '';
  void validateEmail(String val) {
    errorMessage = '';
    if (val.isEmpty) {
      setState(() {
        errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, false, true)) {
      setState(() {
        errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        errorMessage = "";
      });
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromLatLang(double latitude, double longitude) async {
    lat = latitude;
    lng = longitude;

    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemark[0];
    address =
        '${place.street},${place.locality}, ${place.administrativeArea},  ${place.country}';
    addressController.text = address;
  }

  void addMarkerOnPosition(double latitude, double longitude) {
    markers.removeAt(0);
    markers.add(
        Marker(markerId: const MarkerId('2'), position: LatLng(latitude, longitude)));
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17,
    );
    final GoogleMapController googleMapController = _controller;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    getAddressFromLatLang(latitude, longitude);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mapHeight == 150
          ? AppBar(
              backgroundColor: kBackgroundColor,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Image(
                  width: 24,
                  color: Colors.blue,
                  image: Svg('assets/images/back_arrow.svg'),
                ),
              ),
            )
          : AppBar(
              leading: (mapHeight == 150)
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        mapHeight = 150;
                        setState(() {});
                      },
                      icon: const Icon(Icons.arrow_back)),
            ),
      bottomNavigationBar: mapHeight == 150
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MyTextButton(
                buttonName: 'Done',
                onTap: () {
                  mapHeight = 150;
                  setState(() {});
                },
                bgColor: Colors.blue,
                textColor: Colors.white,
                isLoading: false,
              ),
            ),
      floatingActionButton: mapHeight == 150
          ? null
          : FloatingActionButton(
              onPressed: () {
                getUserCurrentLocation().then((value) {
                  addMarkerOnPosition(value.latitude, value.longitude);
                });
              },
              child: const Icon(Icons.person_pin_circle),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: mapHeight == 150
              ? const BouncingScrollPhysics(parent: BouncingScrollPhysics())
              : const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mapHeight == 150 ? 20 : 0,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Register",
                          style: kHeadline,
                        ),
                        const Text(
                          "Create new account to get started.",
                          style: kBodyText2,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                onChanged: (val) {
                                  name = val;
                                  setState(() {});
                                },
                                style: kBodyText.copyWith(color: Colors.blue),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  hintText: "Pharmacy Name",
                                  hintStyle: kBodyText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          name == "" ? Colors.red : Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          name == "" ? Colors.red : Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              if (name == "")
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Pharmacy Name can't be empty",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                onChanged: (val) {
                                  email = val;
                                  validateEmail(val);
                                },
                                style: kBodyText.copyWith(color: Colors.blue),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  hintText: "Email",
                                  hintStyle: kBodyText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: errorMessage == ''
                                          ? Colors.grey
                                          : Colors.red,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: errorMessage == ''
                                          ? Colors.blue
                                          : Colors.red,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              if (errorMessage != '')
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    errorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                onChanged: (val) {
                                  number = val;
                                  setState(() {});
                                },
                                style: kBodyText.copyWith(color: Colors.blue),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  hintText: "Phone",
                                  hintStyle: kBodyText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: number.length < 11
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: number.length < 11
                                          ? Colors.red
                                          : Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              if (number.length < 11)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Phone number can't be less then 11",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                onChanged: (val) {
                                  password = val;
                                  setState(() {});
                                },
                                style: kBodyText.copyWith(
                                  color: Colors.blue,
                                ),
                                obscureText: passwordVisibility,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        setState(() {
                                          passwordVisibility =
                                              !passwordVisibility;
                                        });
                                      },
                                      icon: Icon(
                                        passwordVisibility
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(20),
                                  hintText: 'Password',
                                  hintStyle: kBodyText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: password.length < 4
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: password.length < 4
                                          ? Colors.red
                                          : Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              if (password.length < 4)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Password can't be less then 4",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: addressController,
                                style: kBodyText.copyWith(color: Colors.blue),
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  hintText: "Pharmacy Address  (pick from map)",
                                  hintStyle: kBodyText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: address == ""
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: address == ""
                                          ? Colors.red
                                          : Colors.blue,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              if (address == "")
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Address can't be empty",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: mapHeight,
                      // width: 300,
                      margin: EdgeInsets.only(
                          bottom: 50, top: mapHeight == 150.0 ? 650 : 0),

                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                      ),
                      child: GoogleMap(
                        markers: markers.toSet(),
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        initialCameraPosition: initialCameraPosition,
                        mapType: MapType.normal,
                        onMapCreated: (controller) {
                          setState(() {
                            _controller = controller;
                          });
                        },
                        onTap: (cordinats) {
                          if (mapHeight == 150) {
                            mapHeight =
                                MediaQuery.of(context).size.height + 200;
                            setState(() {});
                          } else {
                            addMarkerOnPosition(
                                cordinats.latitude, cordinats.longitude);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: kBodyText,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: kBodyText.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextButton(
                  buttonName: 'Register',
                  onTap: () {
                    registerUser();
                  },
                  bgColor: Colors.blue,
                  textColor: Colors.white,
                  isLoading: isLoading,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
