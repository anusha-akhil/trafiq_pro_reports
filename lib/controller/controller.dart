import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_conn/sql_conn.dart';
import '../components/network_connectivity.dart';

class Controller extends ChangeNotifier {
  String? fromDate;
  String? todate;
  bool isLoading = false;
  List<Map<String, dynamic>> dashboard_report = [];
  var result1 = <String, List<Map<String, dynamic>>>{};
  List<Map<String, dynamic>> report_tile_val = [];
  List<Map<String, dynamic>> result = [];

  /////////////////////////////////////////////
  setDate(String date1, String date2) {
    fromDate = date1;
    todate = date2;
    print("gtyy----$fromDate----$todate");
    notifyListeners();
  }

////////////////////////////////////////////////////////
  getHome(
    BuildContext context,
  ) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isLoading = true;
          notifyListeners();
          var res = await SqlConn.readData("Flt_Load_Home '0'");
          print("response map--------$res");
          var valueMap = json.decode(res);
          print("response valueMap--------$valueMap");
          dashboard_report.clear();
          result.clear();
          for (var item in valueMap) {
            if (item["Rpt_Type"] == 0) {
              getDashboardTileVal(context, item["Rpt_Script"], item);
            } else {
              result.add(item);
              // getReportTileVal(context, item["Rpt_Script"], item);
            }
          }
          groupByName(result);
          isLoading = false;

          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  ////////////////////////////////////////////////////////////
  getDashboardTileVal(
      BuildContext context, String sp, Map<String, dynamic> item) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          var res = await SqlConn.readData("$sp '0','1'");
          print("dashboard tile val-------$res");
          var valueMap = json.decode(res);
          item["values"] = valueMap;
          dashboard_report.add(item);
          notifyListeners();
          print("listt------$dashboard_report");
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }
///////////////////////////////////////////////////////////

  void groupByName(var data) {
    report_tile_val.clear();
    result1 = <String, List<Map<String, dynamic>>>{};
    for (var d in data) {
      print(d);
      var e = {
        "Rpt_ID": d["Rpt_ID"]!,
        "Rpt_Order": d["Rpt_Order"]!,
        "Rpt_Type": d["Rpt_Type"]!,
        "Rpt_Group": d["Rpt_Group"]!,
        "Rpt_Name": d["Rpt_Name"]!,
        "Rpt_Script": d["Rpt_Script"]!,
        "Rpt_Key": d["Rpt_Key"]!,
        "Rpt_MultiDt": d["Rpt_MultiDt"]!,
        "Rpt_ColorId": d["Rpt_ColorId"]!,
        "Rpt_ImgID": d["Rpt_ImgID"]!,
      };
      var key = d["Rpt_Group"]!;
      if (result1.containsKey(key)) {
        result1[key]!.add(e);
      } else {
        result1[key] = [e];
      }
    }
    result1.entries.forEach((e) => report_tile_val.add({e.key: e.value}));
    print("result---${report_tile_val}");
    print(result);
  }

  ////////////////////////////////////////////////////////
  getReportTabledata(BuildContext context, String sp, String param) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          var res = await SqlConn.readData("$sp '$param'");
          print("report table----$res");
          var valueMap = json.decode(res);
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }
}
