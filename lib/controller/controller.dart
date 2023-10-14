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
  List<Map<String, dynamic>> dashboard_report_val = [];
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
          var res = await SqlConn.readData("Flt_Load_Home '0'");
          print("response map--------$res");
          var valueMap = json.decode(res);
          print("response valueMap--------$valueMap");
          dashboard_report.clear();
          dashboard_report_val.clear();
          for (var item in valueMap) {
            if (item["Rpt_Type"] == 0) {
              dashboard_report.add(item);
              getDashboardTileVal(context, item["Rpt_Script"], item["Rpt_ID"]);
            } else {}
          }
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
  getDashboardTileVal(BuildContext context, String sp, int rpt_id) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          var res = await SqlConn.readData("$sp '0','1'");
          print("dashboard tile val-------$res");
          var valueMap = json.decode(res);
          Map<String, dynamic> map = {rpt_id.toString(): valueMap};
          dashboard_report_val.add(map);
          notifyListeners();
          print("listt------$dashboard_report_val");
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  ///////////////////////////////////////
  getjsonDash(BuildContext context) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          var res = await SqlConn.readData("Flt_Load_Home1");
          print("from sp-------$res");
          var valueMap = json.decode(res);
          for (var item in valueMap) {
            print("djjdff-----$item");
          }
          print("listt------$dashboard_report_val");
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }
}
