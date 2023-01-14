import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditech_for_pharmacy/Models/Pharmacy.dart';
import 'package:meditech_for_pharmacy/Provider/product_provider.dart';
import 'package:meditech_for_pharmacy/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../Models/Product.dart';
import '../Widgets/my_text_button.dart';
import '../constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({required this.currentUser, this.product, Key? key})
      : super(key: key);

  Pharmacy currentUser;
  Product? product;
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var categoryList = [
    "Category",
    "Tablets",
    "Capsules",
    "Syrup",
    "Drops",
    "Homeopathic",
    "Medical Equipments",
    "Others",
  ];
  TextEditingController nameController = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController totalItemController = TextEditingController();
  var _currentSelectedValue = "Category";
  String expireDate = "Expire Date";
  String imagePath = "";
  File? myImage;
  bool isLoading = false;
  String preImage = "";
  bool uploading = false;
  bool isPickImage = false;
  void setValue() {
    if (widget.product != null) {
      nameController.text = widget.product!.name;
      sellPriceController.text = widget.product!.sellPrice.toString();
      purchasePriceController.text = widget.product!.purchasePrice.toString();
      expireDate = widget.product!.expireDate;
      descriptionController.text = widget.product!.description;
      totalItemController.text = widget.product!.totalItem.toString();
      imagePath = widget.product!.imagePath;
      preImage = widget.product!.imagePath;

      _currentSelectedValue = widget.product!.category;
    }
  }

  void pickImage() async {
    isPickImage = true;
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image!.path;
      myImage = File(imagePath);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: (widget.product != null)
            ? const Text("Update Product")
            : const Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            uploading
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller: nameController,
                            onChanged: (val) {
                              //name = val;
                            },
                            style: kBodyText.copyWith(color: Colors.blue),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "ProductName",
                              contentPadding: const EdgeInsets.all(20),
                              hintText: "Product Name",
                              hintStyle: kBodyText,
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
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      labelText: "Category",
                                      // labelStyle: textStyle,
                                      errorStyle: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 16.0),
                                      hintText: 'Category',
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
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  isEmpty: _currentSelectedValue == '',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _currentSelectedValue,
                                      isDense: true,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _currentSelectedValue = newValue!;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: categoryList.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller: sellPriceController,
                            onChanged: (val) {
                              //  sellPrice = double.parse(val);
                            },
                            style: kBodyText.copyWith(color: Colors.blue),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "SellPrice",
                              contentPadding: const EdgeInsets.all(20),
                              hintText: "Sell Price",
                              hintStyle: kBodyText,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller: purchasePriceController,
                            onChanged: (val) {
                              // purchasePrice = double.parse(val);
                            },
                            style: kBodyText.copyWith(color: Colors.blue),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "PurchasePrice",
                              contentPadding: const EdgeInsets.all(20),
                              hintText: "Purchase Price",
                              hintStyle: kBodyText,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller: descriptionController,
                            onChanged: (val) {
                              // purchasePrice = double.parse(val);
                            },
                            style: kBodyText.copyWith(color: Colors.blue),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            //textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Description",
                              contentPadding: const EdgeInsets.all(20),
                              hintText: "Description",
                              hintStyle: kBodyText,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller: totalItemController,
                            onChanged: (val) {
                              // purchasePrice = double.parse(val);
                            },
                            style: kBodyText.copyWith(color: Colors.blue),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "totalItems",
                              contentPadding: const EdgeInsets.all(20),
                              hintText: "Total Items",
                              hintStyle: kBodyText,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030, 12),
                              ).then((pickedDate) {
                                expireDate =
                                    '${pickedDate!.day}-${pickedDate.month}-${pickedDate.year}';
                                setState(() {});
                              });
                            },
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: const Color(0xffE7E7E8),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey, spreadRadius: 1),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Text(
                                  expireDate,
                                  style: kBodyText,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          child: Container(
                            height: 100,
                            width: 95,
                            decoration: BoxDecoration(
                              color: const Color(0xffE7E7E8),
                              image: DecorationImage(
                                image: (widget.product != null &&
                                        isPickImage != true)
                                    ? NetworkImage(preImage)
                                    : (myImage != null)
                                        ? Image.file(
                                            myImage!,
                                            fit: BoxFit.cover,
                                          ).image
                                        : const AssetImage(
                                            "assets/icons/picture.png",
                                          ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(color: Colors.black, spreadRadius: 2),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            pickImage();
                          },
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        if (productProvider.isLoading)
                          const CircularProgressIndicator()
                        else
                          MyTextButton(
                            buttonName:
                                (widget.product != null) ? 'Update' : 'Add',
                            onTap: () async {
                              Product tempProduct = Product(
                                  (widget.product != null)
                                      ? widget.product!.id
                                      : "",
                                  nameController.text,
                                  _currentSelectedValue,
                                  double.parse(sellPriceController.text),
                                  double.parse(purchasePriceController.text),
                                  descriptionController.text,
                                  int.parse(totalItemController.text),
                                  expireDate,
                                  imagePath,
                                  widget.currentUser.id);

                              if (widget.product != null) {
                                await productProvider.updateProduct(
                                    tempProduct, preImage);
                              } else {
                                await productProvider
                                    .addProduct(tempProduct)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Product Added", // message
                                      toastLength: Toast.LENGTH_SHORT, // length
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      backgroundColor:
                                          Colors.blueAccent, //  // location
                                      timeInSecForIosWeb: 1 // duration
                                      );
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomeScreen()));
                                });
                              }
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
          ],
        ),
      ),
    );
  }
}
