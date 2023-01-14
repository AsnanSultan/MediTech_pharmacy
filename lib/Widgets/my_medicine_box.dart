import 'package:flutter/material.dart';

class MyMedicineBox extends StatelessWidget {
  MyMedicineBox(
      {required this.image,
      required this.name,
      required this.price,
      required this.pharmacy,
      required this.distance,
      Key? key})
      : super(key: key);

  String image;
  String name;
  double price;
  String pharmacy;
  double distance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /* Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductDetailScreen()));*/
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 70, height: 100, child: Image(image: AssetImage(image))),
            const SizedBox(
              width: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text('price: $price'),
                Text('Pharmacy: $pharmacy'),
                Text('Distance: $distance  km'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
