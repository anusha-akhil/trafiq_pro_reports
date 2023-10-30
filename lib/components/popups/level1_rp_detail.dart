import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/components/table_data.dart';

import '../../controller/controller.dart';

class Level1ReportDetails {
  Future viewData(BuildContext context, Map<String, dynamic> map, int index) {
    // Map report_data = {
    //   "id": "3",
    //   "title": "SALES",
    //   "graph": "0",
    //   "sum": "NY",
    //   "align": 'LR',
    //   "width": "60,40",
    //   "search": "0",
    //   "data": [
    //     {"DESCRIPTION": "CASH SALES", 'VALUE': "0"},
    //     {"DESCRIPTION": "CREDIT SALES", "VALUE": "0"},
    //     {"DESCRIPTION": "CARD SALES", "VALUE": "0"},
    //     {"DESCRIPTION": "WALLET,OTHER SALES", "VALUE": "0"}
    //   ]
    // };
    // var jsonEncoded = jsonEncode(report_data);

    print("map-----$map");
    // var jsonEncoded;
    DateFind dateFind = DateFind();
    String? todaydate;
    DateTime now = DateTime.now();
    todaydate = DateFormat('dd-MMM-yyyy').format(now);
    Size size = MediaQuery.of(context).size;
    double appbarHeight = AppBar().preferredSize.height;

    var width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 109, 182, 241),
            contentPadding: EdgeInsets.all(8),
            insetPadding: EdgeInsets.all(8),
            //  backgroundColor: Colors.grey[200],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    map["Rpt_Name"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ))
              ],
            ),
            content: Builder(
              builder: (context) {
                return Consumer<Controller>(
                  builder: (context, value, child) => Container(
                    // color: Colors.black,
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Container(
                          height: size.height * 0.1,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    map["Rpt_MultiDt"] == 0 ||
                                            map["Rpt_MultiDt"] == 1
                                        ? Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    dateFind.selectDateFind(
                                                        context, "from date");
                                                  },
                                                  icon: const Icon(
                                                    Icons.calendar_month,
                                                    // color: P_Settings.loginPagetheme,
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0),
                                                child: Text(
                                                  value.fromDate == null
                                                      ? todaydate.toString()
                                                      : value.fromDate
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    map["Rpt_MultiDt"] == 1
                                        ? Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    dateFind.selectDateFind(
                                                        context, "to date");
                                                  },
                                                  icon: Icon(
                                                      Icons.calendar_month)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  value.todate == null
                                                      ? todaydate.toString()
                                                      : value.todate.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    Flexible(
                                        child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: size.height * 0.05,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.yellow,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      2), // <-- Radius
                                            ),
                                          ),
                                          onPressed: () {
                                            String df;
                                            String tf;

                                            if (value.fromDate == null) {
                                              value.fromDate =
                                                  todaydate.toString();
                                            } else {
                                              value.fromDate =
                                                  value.fromDate.toString();
                                            }
                                            if (value.todate == null) {
                                              value.todate =
                                                  todaydate.toString();
                                            } else {
                                              value.todate =
                                                  value.todate.toString();
                                            }

                                            value.getReportTabledata(
                                                context,
                                                map["Rpt_Script"],
                                                value.fromDate.toString(),
                                                value.todate.toString(),
                                                map["Rpt_Key"]);
                                          },
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.black,
                                          )),
                                    ))
                                  ],
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 13.0),
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       // Text("Filter : "),
                                //       Container(
                                //         margin: EdgeInsets.only(
                                //             left: 2, right: 2, top: 12),
                                //         decoration: BoxDecoration(
                                //           border: Border.all(
                                //               color: Color.fromARGB(
                                //                   255, 163, 163, 163)),
                                //           borderRadius: BorderRadius.circular(3),
                                //         ),
                                //         width: size.width * 0.68,
                                //         height: size.height * 0.05,
                                //         child: ButtonTheme(
                                //           alignedDropdown: true,
                                //           child: DropdownButton<String>(
                                //             // value: selected,
                                //             // isDense: true,
                                //             hint: Text(
                                //               "Apply Filter",
                                //               style: TextStyle(fontSize: 14),
                                //             ),
                                //             isExpanded: true,
                                //             autofocus: false,
                                //             underline: SizedBox(),
                                //             elevation: 0,
                                //             items: [
                                //               "Anus",
                                //               "dansh",
                                //               "sippa",
                                //               "anil"
                                //             ]
                                //                 .map((item) =>
                                //                     DropdownMenuItem<String>(
                                //                         value: item.toString(),
                                //                         child: Container(
                                //                           width: size.width * 0.4,
                                //                           child: Text(
                                //                             item.toString(),
                                //                             style: TextStyle(
                                //                                 fontSize: 14),
                                //                           ),
                                //                         )))
                                //                 .toList(),
                                //             onChanged: (item) {
                                //               print("clicked");
                                //               if (item != null) {
                                //                 print("clicked------$item");
                                //                 // // value.areaId = item;
                                //                 // Provider.of<Controller>(context, listen: false)
                                //                 //     .setDropdowndata(item);
                                //                 // Provider.of<Controller>(context, listen: false)
                                //                 //     .getItemwisereport(
                                //                 //   context,
                                //                 // );
                                //               }
                                //             },
                                //           ),
                                //         ),
                                //       ),

                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        value.isReportLoading
                            ? SpinKitCircle(
                                color: Colors.black,
                              )
                            : value.report_data.length == 0
                                ? Center(
                                    child: Text(
                                      "No Data Found!!!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19),
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                      // height: size.height * 0.5,
                                      // color: Colors.white,
                                      child: TableData(
                                          decodd: value.jsonEncoded,
                                          index: index,
                                          keyVal: "0",
                                          popuWidth: width,
                                          level: 1),
                                    ),
                                  )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
