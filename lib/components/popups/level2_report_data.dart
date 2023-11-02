import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/components/table_data.dart';

import '../../controller/controller.dart';

class Level2ReportDetails {
  Future viewData(BuildContext context, Map map, int index, String val) {
    print("map-----$map");
    // var jsonEncoded;
    DateFind dateFind = DateFind();
    String? todaydate;
    DateTime now = DateTime.now();
    todaydate = DateFormat('dd-MM-yyyy').format(now);
    Size size = MediaQuery.of(context).size;
    double appbarHeight = AppBar().preferredSize.height;

    var width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[400],
            contentPadding: EdgeInsets.all(8),
            insetPadding: EdgeInsets.all(8),
            //  backgroundColor: Colors.grey[200],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  map["Sub_Caption"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                InkWell(
                    onTap: () {
                      Provider.of<Controller>(context, listen: false)
                          .splitParametr("2");
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
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        value.isSubReportLoading
                            ? SpinKitCircle(
                                color: Colors.black,
                              )
                            : value.sub_report_data.length == 0
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
                                        decodd: value.sub_report_json,
                                        index: index,
                                        keyVal: "1",
                                        popuWidth: width,
                                        level: 2,
                                        title: val,
                                      ),
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
