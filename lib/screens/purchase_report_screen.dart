import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

import '../Models/Product.dart';
import '../Provider/pharmacy_provider.dart';

class PurchaseReportScreen extends StatefulWidget {
  const PurchaseReportScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseReportScreen> createState() => _PurchaseReportScreenState();
}

class _PurchaseReportScreenState extends State<PurchaseReportScreen> {
  List<charts.Series<Category, String>> _seriesBarData = [];
  List<charts.Series<Category, String>> _seriesPieData = [];
  _genrateData(List<Product> productList) {
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
      switch (productList[i].category) {
        case 'Tablets':
          tablets += productList[i].totalItem;
          tabletsPrice +=
              productList[i].totalItem * productList[i].purchasePrice;
          break;
        case 'Capsules':
          capsules += productList[i].totalItem;
          capsulesPrice +=
              productList[i].totalItem * productList[i].purchasePrice;
          break;
        case 'Syrup':
          syrup += productList[i].totalItem;
          syrupPrice += productList[i].totalItem * productList[i].purchasePrice;
          break;
        case 'Drops':
          drops += productList[i].totalItem;
          dropsPrice += productList[i].totalItem * productList[i].purchasePrice;
          break;
        case 'Homeopathic':
          homeopathic += productList[i].totalItem;
          homeopathicPrice +=
              productList[i].totalItem * productList[i].purchasePrice;
          break;
        case 'Medical Equipments':
          equipments += productList[i].totalItem;
          equipmentsPrice +=
              productList[i].totalItem * productList[i].purchasePrice;
          break;
        case 'Others':
          others += productList[i].totalItem;
          othersPrice +=
              productList[i].totalItem * productList[i].purchasePrice;
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PharmacyProvider pharmacyProvider = Provider.of<PharmacyProvider>(context);
    _genrateData(pharmacyProvider.productList);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Purchase Report"),
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
                                fontSize: 16,
                              ),
                            ),
                          ],
                          defaultRenderer: charts.ArcRendererConfig(
                              arcWidth: 160,
                              arcRendererDecorators: [
                                charts.ArcLabelDecorator(
                                    labelPosition: charts.ArcLabelPosition.auto,
                                    insideLabelStyleSpec: charts.TextStyleSpec(
                                        fontSize: 22,
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
