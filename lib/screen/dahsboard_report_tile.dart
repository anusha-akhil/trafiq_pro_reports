import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/controller/controller.dart';

class DashboardReport extends StatefulWidget {
  const DashboardReport({super.key});

  @override
  State<DashboardReport> createState() => _DashboardReportState();
}

class _DashboardReportState extends State<DashboardReport> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<Controller>(
      builder: (context, value, child) => Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //      SizedBox(
          //       width: 10,
          //     ),
          //     Text(
          //       value.dashboard_report[0]["Rpt_Group"],
          //       style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          //     ),
          //   ],
          // ),
          // SizedBox(height: size.height*0.01,),
          Container(
            height: size.height * 0.19,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: value.dashboard_report.length,
              itemBuilder: (context, index) {
                if (value.dashboard_report[index]["values"][0].length == 1) {
                  print("1---sfjknkjdfnd");
                  return singlevalContainer(
                      size, value.dashboard_report[index]);
                } else {
                  print(
                      "cbjhzdbhzcb----${value.dashboard_report[index]["values"]}");
                  return multipleValueContainer(
                      size, value.dashboard_report[index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget singlevalContainer(Size size, Map<String, dynamic> map) {
    Map<String, dynamic> valueMap = map["values"][0];
    print("values-------$valueMap");
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 4, 136, 243),
                Color.fromARGB(255, 160, 198, 229),
              ],
            )),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                map["Rpt_Name"].toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              Text(valueMap.values.first.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }

  Widget multipleValueContainer(Size size, Map<String, dynamic> map) {
    List<Map<String, dynamic>> valueMap = [];
    map["values"][0].entries.forEach((e) => valueMap.add({e.key: e.value}));
    print("values-------$valueMap");

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Text(
                map["Rpt_Name"].toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
              Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: valueMap
                      .map((item) => Row(
                            children: [
                              VerticalDivider(
                                color: Colors.transparent,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item.keys.first.toString().toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 250, 225, 3),
                                          fontSize: 14)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(item.values.first.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 17))
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.transparent,
                              )
                            ],
                          ))
                      .toList()),
            ],
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 224, 108, 245),
                Colors.blue,
              ],
            )),
      ),
    );
  }
}
