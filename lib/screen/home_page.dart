import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:trafiqpro/screen/report_tabs.dart';

import '../controller/controller.dart';
import 'dahsboard_report_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> staffData = [
    {"staff_id": "1", "name": "anusha"},
    {"staff_id": "2", "name": "shilpa"},
    {"staff_id": "3", "name": "danush"}
  ];
  String? selected;
  Future<void> connect(BuildContext ctx) async {
    debugPrint("Connecting...");
    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Please wait",
                  style: TextStyle(fontSize: 13),
                ),
                SpinKitCircle(
                  color: Colors.green,
                )
              ],
            ),
          );
        },
      );
      await SqlConn.connect(
          ip: "103.177.225.245",
          port: "54321",
          databaseName: "ReportServer\$S2016",
          username: "sa",
          password: "##v0e3g9a#");
      debugPrint("Connected!");
      Provider.of<Controller>(context, listen: false)
          .getHome(context, todaydate.toString());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  String? todaydate;

  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todaydate = DateFormat('dd-MMM-yyyy').format(now);
    // Provider.of<Controller>(context, listen: false).findPreviuosdate(now);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      connect(context);
      // Provider.of<Controller>(context, listen: false).getjsonDash(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Company Name",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<Controller>(
          builder: (context, value, child) => Column(
            children: [
              Container(
                height: size.height * 0.07,
                // color: Colors.grey[200],
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.34,
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //       color: Colors.white),
                      //   borderRadius: BorderRadius.circular(28),
                      // ),
                      // width: size.width * 0.4,
                      height: size.height * 0.04,

                      child: ButtonTheme(
                        // alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: selected,
                          // isDense: true,
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 9.0),
                            child: Text(
                              "Select Branch",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ),
                          isExpanded: false,
                          autofocus: false,
                          underline: SizedBox(),
                          elevation: 0,
                          items: staffData
                              .map((item) => DropdownMenuItem<String>(
                                  value: item["staff_id"].toString(),
                                  child: Container(
                                    // width: size.width * 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 9.0),
                                      child: Text(
                                        item["name"].toString(),
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue),
                                      ),
                                    ),
                                  )))
                              .toList(),
                          onChanged: (item) {
                            print("clicked");

                            if (item != null) {
                              setState(() {
                                selected = item;
                              });
                              print("clicked------$item");
                            }
                          },
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0),
                    //   child: Text(
                    //     "Branch",
                    //     style: TextStyle(
                    //         color: Colors.blue, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Provider.of<Controller>(context, listen: false)
                                  .findDate(value.d, "prev", context);
                            },
                            child: Image.asset("assets/left.png",
                                height: size.height * 0.021,
                                color: Colors.yellow),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Text(
                              value.dashDate == null
                                  ? todaydate.toString()
                                  : value.dashDate.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Provider.of<Controller>(context, listen: false)
                                  .findDate(value.d, "after", context);
                            },
                            child: Image.asset("assets/right.png",
                                height: size.height * 0.021,
                                color: Colors.yellow),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.white,
                // height: 25,
              ),
              value.isLoading
                  ? Center(
                      child: SpinKitCircle(
                      color: Colors.white,
                    ))
                  : DashboardReport(),
              ReportTabs()
            ],
          ),
        ),
      ),
    );
  }
}
