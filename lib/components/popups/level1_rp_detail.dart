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
  Future viewData(
      BuildContext context, Map<String, dynamic> map, int index, int rpt_key) {
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

    print("single map-----$map");
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
                  ),
                ),
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
                                            borderRadius: BorderRadius.circular(
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
                                            value.todate = todaydate.toString();
                                          } else {
                                            value.todate =
                                                value.todate.toString();
                                          }
                                          value.getReportTabledata(
                                              context,
                                              map["Rpt_Script"],
                                              value.fromDate.toString(),
                                              value.todate.toString(),
                                              map["Rpt_MultiDt"]);
                                        },
                                        child: const Icon(
                                          Icons.done,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
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
                                    child: TableData(
                                        decodd: value.jsonEncoded,
                                        index: index,
                                        keyVal: "1",
                                        popuWidth: width,
                                        level: 1,
                                        title: "",
                                        rpt_key: rpt_key.toString()),
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
