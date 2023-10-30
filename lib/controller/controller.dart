import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:trafiqpro/components/popups/level2_report_data.dart';
import 'package:trafiqpro/components/popups/level3_report.dart';
import '../components/network_connectivity.dart';

class Controller extends ChangeNotifier {
  String? fromDate;
  var jsonEncoded;
  String? todate;
  List<TextEditingController> listEditor = [];
  Map<String, dynamic> levelCriteria = {};
  bool isLoading = false;
  bool isReportLoading = false;

  List<Map<String, dynamic>> dashboard_report = [];
  var result1 = <String, List<Map<String, dynamic>>>{};
  List<Map<String, dynamic>> report_tile_val = [];
  List<Map<String, dynamic>> result = [];
  List<Map<String, dynamic>> sub_report = [];
  List<Map<String, dynamic>> report_data = [];
  Map<String, dynamic> sub_report_data = {};
  var sub_report_json;
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
  getReportTabledata(
      BuildContext context, String sp, String date1, String date2, String key) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isReportLoading = true;
          notifyListeners();
          print("parameters--------------$sp-----$date1,$date2");
          var res = await SqlConn.readData("$sp '0','1',$date1,$date2");
          print("report table----$res");
          var valueMap = json.decode(res);
          print("value map----$valueMap");
          report_data.clear();
          for (var item in valueMap) {
            report_data.add(item);
          }
          jsonEncoded = jsonEncode(report_data);
          isReportLoading = false;
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

/////////////////////////////////////////////////////////////////
  getSubReport(BuildContext context, int rptId) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          print("rprttt-Id----$rptId");
          var res = await SqlConn.readData("Flt_SubReport '0','1', $rptId");
          var map = jsonDecode(res);
          sub_report.clear();
          for (var item in map) {
            sub_report.add(item);
          }
          print("sub report----$sub_report");
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  /////////////////////////////////////////////////////////////
  findLevelCriteria(
    BuildContext context,
    int level,
    int index,
  ) {
    print("level-----$level");
    levelCriteria = {};
    if (sub_report.isNotEmpty) {
      for (var item in sub_report) {
        if (item["Sub_Order"] == level) {
          levelCriteria = item;
        }
      }

      // getReportTabledata(context, levelCriteria["Sub_Script"], "");
      getSubreportData(context, levelCriteria["Sub_Script"],
          fromDate.toString(), todate.toString(), levelCriteria["Sub_Key"]);
      if (level == 1) {
        Level2ReportDetails popup = Level2ReportDetails();
        popup.viewData(context, levelCriteria, index);
      } else if (level == 2) {
        Level3ReportDetails popup = Level3ReportDetails();
        popup.viewData(context, levelCriteria, level, index);
      }
    }
    print("levelcriteria--------$levelCriteria");
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////
  getSubreportData(
      BuildContext context, String sp, String date1, String date2, String key) {
    NetConnection.networkConnection(context).then((value) async {
      print("parameters----------------$sp-----$date1----$date2----$key");
      if (value == true) {
        try {
          sub_report_data = {
            "id": "3",
            "title": "SALES",
            "graph": "0",
            "sum": "NY",
            "align": 'LR',
            "width": "60,40",
            "search": "0",
            "data": [
              {"name": "anusha", 'VALUE': "0"},
              {"name": "anugraha", "VALUE": "0"},
              {"name": "danush", "VALUE": "0"},
              {"name": "shilpa", "VALUE": "0"},
              {"name": "anil", 'VALUE': "0"},
            ]
          };
          sub_report_json = jsonEncode(sub_report_data);

          // print("rprttt-Id----$sp");
          // var res = await SqlConn.readData("$sp '0','1', $date1, $date2, $key");
          // var map = jsonDecode(res);
          // sub_report_data.clear();
          // for (var item in map) {
          //   sub_report_data.add(item);
          // }
          print("sub_report_data---$sub_report_data");
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }
}
