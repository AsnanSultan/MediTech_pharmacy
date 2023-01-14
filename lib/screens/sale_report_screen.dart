import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:meditech_for_pharmacy/Provider/OrderProvider.dart';
import 'package:provider/provider.dart';

import '../Models/Cart.dart';
import '../Models/Product.dart';
import '../Provider/pharmacy_provider.dart';

class SaleReportScreen extends StatefulWidget {
  const SaleReportScreen({Key? key}) : super(key: key);

  @override
  State<SaleReportScreen> createState() => _SaleReportScreenState();
}

class _SaleReportScreenState extends State<SaleReportScreen> {
  List<charts.Series<Category, String>> _seriesBarData = [];
  List<charts.Series<Category, String>> _seriesPieData = [];
  _genrateData(List<Product> productList, List<Cart> cartList) {
    _seriesBarData = [];
    _seriesPieData = [];
    double tablets = 0,
        capsules = 0,
        syrup = 0,
        drops = 0,
        homeopathic = 0,
        equipments = 0,
        others = 0;
    double tabletsPrice = 0,
        capsulesPrice = 0,
        syrupPrice = 0,
        dropsPrice = 0,
        homeopathicPrice = 0,
        equipmentsPrice = 0,
        othersPrice = 0;
    for (int i = 0; i < productList.length; i++) {
      Cart tempCart = cartList
          .firstWhere((element) => element.productId == productList[i].id);
      // print('count value: ${tempCart.count}');
      switch (productList[i].category) {
        case 'Tablets':
          tablets += tempCart.count;
          tabletsPrice += tempCart.count * productList[i].purchasePrice;
          break;
        case 'Capsules':
          capsules += tempCart.count;
          capsulesPrice += tempCart.count * productList[i].purchasePrice;
          break;
        case 'Syrup':
          syrup += tempCart.count;
          syrupPrice += tempCart.count * productList[i].purchasePrice;
          break;
        case 'Drops':
          drops += tempCart.count;
          dropsPrice += tempCart.count * productList[i].purchasePrice;
          break;
        case 'Homeopathic':
          homeopathic += tempCart.count;
          homeopathicPrice += tempCart.count * productList[i].purchasePrice;
          break;
        case 'Medical Equipments':
          equipments += tempCart.count;
          equipmentsPrice += tempCart.count * productList[i].purchasePrice;
          break;
        case 'Others':
          others += tempCart.count;
          othersPrice += tempCart.count * productList[i].purchasePrice;
          break;
      }
    }

    var pieData = [
      Category(category: "Tablets", colorVal: Colors.blue, value: tablets),
      Category(
          category: "Capsules", colorVal: Colors.cyanAccent, value: capsules),
      Category(category: "Syrup", colorVal: Colors.purple, value: syrup),
      Category(category: "Drops", colorVal: Colors.yellow, value: drops),
      Category(
          category: "Homeopathic", colorVal: Colors.orange, value: homeopathic),
      Category(
          category: "Medical Equipments",
          colorVal: Colors.green,
          value: equipments),
      Category(category: "Others", colorVal: Colors.deepPurple, value: others),
    ];
    var barData = [
      Category(category: "Tablets", colorVal: Colors.blue, value: tabletsPrice),
      Category(
          category: "Capsules",
          colorVal: Colors.cyanAccent,
          value: capsulesPrice),
      Category(category: "Syrup", colorVal: Colors.purple, value: syrupPrice),
      Category(category: "Drops", colorVal: Colors.yellow, value: dropsPrice),
      Category(
          category: "Homeopathic",
          colorVal: Colors.orange,
          value: homeopathicPrice),
      Category(
          category: "Medical Equipments",
          colorVal: Colors.green,
          value: equipmentsPrice),
      Category(
          category: "Others", colorVal: Colors.deepPurple, value: othersPrice),
    ];
    _seriesPieData.add(charts.Series(
      data: pieData,
      domainFn: (Category category, _) => category.category,
      measureFn: (Category category, _) => category.value,
      colorFn: (Category category, _) =>
          charts.ColorUtil.fromDartColor(category.colorVal),
      id: "Category",
      labelAccessorFn: (Category row, _) => '${row.value}',
    ));
    _seriesBarData.add(charts.Series(
      data: barData,
      domainFn: (Category category, _) => category.category,
      measureFn: (Category category, _) => category.value,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      fillColorFn: (Category category, _) =>
          charts.ColorUtil.fromDartColor(category.colorVal),
      id: "Category",
    ));
  }

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    List<Product> sellingProducts = [];

    List<Cart> cartList = [];
    for (var element in orderProvider.orderList) {
      if (element.isCompleted) {
        for (var cart in element.cartList) {
          for (int i = 0; i < pharmacyProvider.productList.length; i++) {
            if (pharmacyProvider.productList[i].id == cart.productId) {
              sellingProducts.add(pharmacyProvider.productList[i]);
              cartList.add(cart);
            }
          }

          /* sellingProducts.addAll(pharmacyProvider.productList
              .where((product) => product.id == cart.productId));*/
        }
      }
    }

    _genrateData(sellingProducts, cartList);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Selling Report"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.add_chart),
              ),
              Tab(
                icon: Icon(Icons.add_chart),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      const Text("Report on the basis of Quantity"),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: charts.PieChart(
                          _seriesPieData,
                          animate: true,
                          animationDuration: const Duration(seconds: 3),
                          behaviors: [
                            charts.DatumLegend(
                              outsideJustification:
                                  charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 3,
                              cellPadding:
                                  const EdgeInsets.only(right: 4, bottom: 4),
                              entryTextStyle: charts.TextStyleSpec(
                                color:
                                    charts.MaterialPalette.purple.shadeDefault,
                                fontFamily: 'Georgia',
                                fontSize: 12,
                              ),
                            ),
                          ],
                          defaultRenderer: charts.ArcRendererConfig(
                              arcWidth: 160,
                              arcRendererDecorators: [
                                charts.ArcLabelDecorator(
                                    labelPosition: charts.ArcLabelPosition.auto,
                                    insideLabelStyleSpec: charts.TextStyleSpec(
                                        fontSize: 20,
                                        color: charts.Color.fromHex(
                                            code: "#000000")))
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8, right: 8, top: 50, bottom: 200),
              child: SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    children: [
                      const Text("Report on the basis of Price"),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: charts.BarChart(
                          _seriesBarData,
                          animate: true,
                          animationDuration: const Duration(seconds: 3),
                          barGroupingType: charts.BarGroupingType.grouped,
                          behaviors: [
                            charts.ChartTitle('Category',
                                behaviorPosition:
                                    charts.BehaviorPosition.bottom,
                                titleOutsideJustification:
                                    charts.OutsideJustification.middleDrawArea),
                            charts.ChartTitle('Prices in Pkr',
                                behaviorPosition: charts.BehaviorPosition.start,
                                titleOutsideJustification:
                                    charts.OutsideJustification.middleDrawArea),
                          ],
                          domainAxis: const charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  minimumPaddingBetweenLabelsPx: 0,
                                  labelAnchor: charts.TickLabelAnchor.centered,
                                  labelStyle: charts.TextStyleSpec(
                                    fontSize: 10,
                                    color: charts.MaterialPalette.black,
                                  ),
                                  labelRotation: 60,
                                  // Change the line colors to match text color.
                                  lineStyle: charts.LineStyleSpec(
                                      color: charts.MaterialPalette.black))),
                          secondaryMeasureAxis: const charts.NumericAxisSpec(
                              tickProviderSpec:
                                  charts.BasicNumericTickProviderSpec(
                                      desiredTickCount: 10)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Category {
  String category;
  double value;
  Color colorVal;
  Category(
      {required this.category, required this.colorVal, required this.value});
}
