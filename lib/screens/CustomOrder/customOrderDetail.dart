import 'package:flutter/material.dart';
import 'package:meditech_for_pharmacy/Provider/CustomOrderProvider.dart';
import 'package:meditech_for_pharmacy/Widgets/my_text_button.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Models/CustomOrder.dart';

class CustomOrderDetailScreen extends StatefulWidget {
  CustomOrderDetailScreen({required this.customOrder, Key? key})
      : super(key: key);
  CustomOrder customOrder;

  @override
  State<CustomOrderDetailScreen> createState() =>
      _CustomOrderDetailScreenState();
}

class _CustomOrderDetailScreenState extends State<CustomOrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    CustomOrderProvider customOrderProvider =
        Provider.of<CustomOrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Order Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.customOrder.prescription != "null")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prescription: ",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 200,
                    width: 180,
                    margin: EdgeInsets.only(left: 80),
                    child: Image.network(
                      '${widget.customOrder.prescription}',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 40,
            ),
            if (widget.customOrder.instruction != 'null')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Instruction: ",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text('${widget.customOrder.instruction}'),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text('${widget.customOrder.status}',
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
            Spacer(),
            if (widget.customOrder.status == "Requested")
              MyTextButton(
                  buttonName: "Accept this custom order request",
                  onTap: () async {
                    await customOrderProvider
                        .acceptRequest(widget.customOrder)
                        .then((value) {
                      widget.customOrder.status = "Accepted";
                      Fluttertoast.showToast(
                          msg: "Return/Exchange Request Accepted", // message
                          toastLength: Toast.LENGTH_SHORT, // length
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.white,
                          backgroundColor: Colors.blueAccent, //  // location
                          timeInSecForIosWeb: 1 // duration
                          );
                    });
                    setState(() {});
                  },
                  bgColor: Colors.blueAccent,
                  textColor: Colors.white,
                  isLoading: customOrderProvider.isLoading),
          ],
        ),
      ),
    );
  }
}
