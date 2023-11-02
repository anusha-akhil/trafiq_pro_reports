import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:trafiqpro/components/popups/level2_report_data.dart';
import 'package:trafiqpro/components/popups/level3_report.dart';
import '../components/network_connectivity.dart';

class Controller extends ChangeNotifier {
  String? fromDate;
  var jsonEncoded;
  String? dashDate;
  DateTime d = DateTime.now();
  String? todate;
  List<TextEditingController> listEditor = [];
  Map<String, dynamic> levelCriteria = {};
  bool isLoading = false;
  bool isReportLoading = false;
  bool isSubReportLoading = false;
  bool isl3SubReportLoading = false;
  List<Map<String, dynamic>> dashboard_report = [];
  var result1 = <String, List<Map<String, dynamic>>>{};
  List<Map<String, dynamic>> report_tile_val = [];
  List<Map<String, dynamic>> result = [];
  List<Map<String, dynamic>> sub_report = [];
  List<Map<String, dynamic>> report_data = [];
  List<Map<String, dynamic>> sub_report_data = [];
  List<Map<String, dynamic>> l3_sub_report_data = [];

  var sub_report_json;
  var l3_sub_report_json;
  String param = "";
  /////////////////////////////////////////////
  setDate(String date1, String date2) {
    fromDate = date1;
    todate = date2;
    print("gtyy----$fromDate----$todate");
    notifyListeners();
  }

////////////////////////////////////////////////////////
  getHome(BuildContext context, String date) {
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
    BuildContext context,
    String sp,
    String date1,
    String date2,
  ) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isReportLoading = true;
          notifyListeners();
          param = "'$date1','$date2'";
          print("parameters--------------$sp-----$date1,$date2");
          var res = await SqlConn.readData("$sp '0','1',$param");
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
      BuildContext context, int level, int index, String val) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // pre
    print("level-----$level");
    levelCriteria = {};
    if (sub_report.isNotEmpty) {
      for (var item in sub_report) {
        if (item["Sub_Order"] == level) {
          levelCriteria = item;
        }
      }

      // getReportTabledata(context, levelCriteria["Sub_Script"], "");

      if (level == 1) {
        param = "$param,'$val'";
        Level2ReportDetails popup = Level2ReportDetails();
        popup.viewData(context, levelCriteria, index, val);
        getL2SubreportData(context, levelCriteria["Sub_Script"],
            fromDate.toString(), todate.toString(), param);
      } else if (level == 2) {
        Level3ReportDetails popup = Level3ReportDetails();
        popup.viewData(context, levelCriteria, index, val);
        param = "$param,'$val'";
        getL3SubreportData(context, levelCriteria["Sub_Script"],
            fromDate.toString(), todate.toString(), param);
      }
    }
    print("levelcriteria--------$levelCriteria");
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////
  getL2SubreportData(
      BuildContext context, String sp, String date1, String date2, String val) {
    NetConnection.networkConnection(context).then((value) async {
      print(
          "sub parameters----------------$sp,'0','1','$date1','$date2','$val'");
      if (value == true) {
        try {
          isSubReportLoading = true;
          notifyListeners();
          var res = await SqlConn.readData("$sp 0,1,$val");
          print("sub report table----$res");
          var valueMap = json.decode(res);
          print("sub report value map----$valueMap");
          sub_report_data.clear();
          for (var item in valueMap) {
            sub_report_data.add(item);
          }
          sub_report_json = jsonEncode(sub_report_data);
          print("subreport json----$sub_report_json");
          isSubReportLoading = false;
          notifyListeners();
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

  ///////////////////////////////////////////////////////////////////////////
  getL3SubreportData(
      BuildContext context, String sp, String date1, String date2, String val) {
    NetConnection.networkConnection(context).then((value) async {
      print("sub l3 parameters----------------$sp,'0','1',$val");
      if (value == true) {
        try {
          isl3SubReportLoading = true;
          notifyListeners();
          print("param-------$val");
          var res = await SqlConn.readData("$sp '0','1',$val");
          print("sub l3 report table----$res");
          var valueMap = json.decode(res);
          sub_report_data.clear();
          for (var item in valueMap) {
            sub_report_data.add(item);
          }
          sub_report_json = jsonEncode(sub_report_data);
          print("l3 subreport json----$sub_report_json");
          isl3SubReportLoading = false;
          notifyListeners();
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }
  //////////////////////////////////////////////////////////////////////////////////////////
  splitParametr(String level) {
    List listParam = param.split(',');
    if (level == "2") {
      param = "${listParam[0]},${listParam[1]}";
      print("listparam1--------$param");
    } else if (level == "3") {
      param = "${listParam[0]},${listParam[1]},${listParam[2]}";
    }
    notifyListeners();
  }
  //////////////////////////////////////////////////////////////////////////////////////////
  findDate(DateTime date, String type, BuildContext context) {
    if (type == "prev") {
      // d = date.subtract(Duration(days: i));
      d = DateTime(date.year, date.month, date.day - 1);
      dashDate = DateFormat('dd-MMM-yyyy').format(d);
      getHome(context, dashDate.toString());
    } else {
      if (DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day) !=
          DateTime(date.year, date.month, date.day)) {
        d = DateTime(date.year, date.month, date.day + 1);
        dashDate = DateFormat('dd-MMM-yyyy').format(d);
        getHome(context, dashDate.toString());
      }
    }
    notifyListeners();
  }
}
