import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:trafiqpro/components/popups/level2_report_data.dart';
import 'package:trafiqpro/components/popups/level3_report.dart';
import 'package:trafiqpro/screen/home_page.dart';
import '../components/network_connectivity.dart';

class Controller extends ChangeNotifier {
  String? fromDate;
  String? cName;
  var l3_sub_report_data_json;
  String? yr;
  String? branchid;
  String? branchname;
  String? selected;
  var jsonEncoded;
  String poptitle = "";
  bool isDbNameLoading = false;
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

  List<Map<String, dynamic>> branch_list = [];

  List<Map<String, dynamic>> l3_sub_report_data = [];

  var sub_report_json;
  var l3_sub_report_json;
  String param = "";
  /////////////////////////////////////////////

  ////////////////////////////////////
  setDate(String date1, String date2) {
    fromDate = date1;
    todate = date2;
    print("gtyy----$fromDate----$todate");
    notifyListeners();
  }

////////////////////////////////////////////////////////
  getHome(BuildContext context, String date, String branch) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isLoading = true;
          notifyListeners();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");
          print("home pram------$cid-----$db");
          var res = await SqlConn.readData("Flt_Load_Home '$db','$cid'");
          print("response map--------$res");
          var valueMap = json.decode(res);
          print("response valueMap--------$valueMap");
          dashboard_report.clear();
          result.clear();
          for (var item in valueMap) {
            if (item["Rpt_Type"] == 0) {
              getDashboardTileVal(
                  context, item["Rpt_Script"], item, date, branch);
            } else if (item["Rpt_Type"] == 1) {
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
  getDashboardTileVal(BuildContext context, String sp,
      Map<String, dynamic> item, String date, String branch) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          print("dashboard tile val-------$date ------$branch");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res =
              await SqlConn.readData("$sp '$db','$cid','$branch','$date'");
          var valueMap = json.decode(res);
          if (valueMap != null) {
            item["values"] = valueMap;
          }
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
  getReportTabledata(BuildContext context, String sp, String date1,
      String date2, int multidate) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isReportLoading = true;
          notifyListeners();
          if (multidate == 0) {
            param = "'$date1','$date1'";
          } else {
            param = "'$date1','$date2'";
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          print("parameters--------------$sp-----$param");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res = await SqlConn.readData("$sp  '$db', '$cid','$brId',$param");
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res = await SqlConn.readData(
              "Flt_SubReport '$db','$cid','$brId', $rptId");
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
  findLevelCriteria(BuildContext context, int level, int index, String val,
      String tit) async {
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

      if (level == 1) {
        param = "$param,'$val'";
        poptitle = tit;
        Level2ReportDetails popup = Level2ReportDetails();
        popup.viewData(context, levelCriteria, index, poptitle,
            levelCriteria["Sub_Key"].toString());
        getL2SubreportData(context, levelCriteria["Sub_Script"],
            fromDate.toString(), todate.toString(), param);
      } else if (level == 2) {
        poptitle = '$poptitle' + '/' + '$tit';

        Level3ReportDetails popup = Level3ReportDetails();
        popup.viewData(context, levelCriteria, index, poptitle,
            levelCriteria["Sub_Key"].toString());
        param = "$param,'$val'";
        getL3SubreportData(context, levelCriteria["Sub_Script"],
            fromDate.toString(), todate.toString(), param);
      }
    }
    print("levelcriteria--------$levelCriteria");
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////
  getL2SubreportData(
    BuildContext context,
    String sp,
    String date1,
    String date2,
    String val,
  ) {
    NetConnection.networkConnection(context).then((value) async {
      print(
          "sub parameters----------------$sp,'0','1','$date1','$date2','$val'");
      if (value == true) {
        try {
          isSubReportLoading = true;
          notifyListeners();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res = await SqlConn.readData("$sp  '$db','$cid','$brId',$val");
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

  /////////////////////////////////////////////////////////////////////
  getL3SubreportData(
      BuildContext context, String sp, String date1, String date2, String val) {
    NetConnection.networkConnection(context).then((value) async {
      print("sub l3 parameters----------------$sp,'0','1',$val");
      if (value == true) {
        try {
          isl3SubReportLoading = true;
          notifyListeners();
          print("param-------$val");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? brId = await prefs.getString("br_id");
          String? cid = await prefs.getString("cid");
          String? db = prefs.getString("db_name");

          var res = await SqlConn.readData("$sp '$db','$cid','$brId',$val");
          print("sub l3 report table----$res");
          var valueMap = json.decode(res);
          l3_sub_report_data.clear();
          for (var item in valueMap) {
            l3_sub_report_data.add(item);
          }
          l3_sub_report_data_json = jsonEncode(l3_sub_report_data);
          print("l3 subreport json----$l3_sub_report_data_json");
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

  ///////////////////////////////////////////////////////////////////
  splitParametr(String level) {
    List listParam = param.split(',');
    List listpop = poptitle.split('/');

    if (level == "2") {
      param = "${listParam[0]},${listParam[1]}";
      print("listparam1--------$param");
    } else if (level == "3") {
      param = "${listParam[0]},${listParam[1]},${listParam[2]}";
      poptitle = listpop[0];
    }

    print("param----------$param");
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////
  findDate(DateTime date, String type, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? brId = await prefs.getString("br_id");
    if (type == "prev") {
      // d = date.subtract(Duration(days: i));
      d = DateTime(date.year, date.month, date.day - 1);
      dashDate = DateFormat('dd-MMM-yyyy').format(d);
      getHome(context, dashDate.toString(), brId.toString());
    } else {
      if (DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day) !=
          DateTime(date.year, date.month, date.day)) {
        d = DateTime(date.year, date.month, date.day + 1);
        dashDate = DateFormat('dd-MMM-yyyy').format(d);
        getHome(context, dashDate.toString(), brId.toString());
      }
    }
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////
  getBranches(BuildContext context, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = await prefs.getString("cid");
    String? db = prefs.getString("db_name");

    var res = await SqlConn.readData("Flt_Load_Branches '$db','$cid'");
    print("barnch res-$res");

    var valueMap = json.decode(res);
    branch_list.clear();
    if (valueMap != null) {
      for (var item in valueMap) {
        branch_list.add(item);
      }
      selected = branch_list[0]['Br_Name'];
      branchid = branch_list[0]['Br_ID'].toString();
      prefs.setString("br_id", branchid.toString());
      getHome(context, date, branchid.toString());
    } else {
      prefs.setString("br_id", "0");

      getHome(context, date, "0");
    }

    notifyListeners();
  }

  setDropdowndata(String s, String date, BuildContext context) async {
    // branchid = s;
    for (int i = 0; i < branch_list.length; i++) {
      if (branch_list[i]["Br_ID"].toString() == s.toString()) {
        selected = branch_list[i]["Br_Name"];
        branchid = branch_list[i]["Br_ID"].toString();
        print("s------$s---$selected");

        notifyListeners();
      }
    }
    getHome(context, date, branchid.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("br_id", branchid.toString());
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////////////////
  initYearsDb(BuildContext context, String db) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("db nam--$db");
    String? ip = prefs.getString("ip");
    String? port = prefs.getString("port");
    String? un = prefs.getString("usern");
    String? pw = prefs.getString("pass_w");
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
          ip: ip!, port: port!, databaseName: db, username: un!, password: pw!);
      debugPrint("Connected!");

      print("pishkuuuuu");
      // navigationtoPage(context);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  /////////////////////////////////////////////////////////////////
  getDbName() async {
    isDbNameLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    yr = prefs.getString("yr_name");
    cName = prefs.getString("cname");

    isDbNameLoading = false;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////
  // navigationtoPage(BuildContext context) {
  //   print("yes here");

  // }
}
