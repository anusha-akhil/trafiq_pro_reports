import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/components/date_find.dart';
import 'package:trafiqpro/controller/controller.dart';

class LedgerReport extends StatefulWidget {
  Map<String, dynamic> map = {};
  String id;
  String title;


  LedgerReport({required this.map, required this.id,required this.title});

  @override
  State<LedgerReport> createState() => _LedgerReportState();
}

class _LedgerReportState extends State<LedgerReport> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateFind dateFind = DateFind();
    String? todaydate;
    DateTime now = DateTime.now();

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      todaydate = DateFormat('dd-MMM-yyyy').format(now);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ledger (${widget.title})",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.blue,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Column(
            children: [
              Container(
                height: size.height * 0.1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.map["Rpt_MultiDt"] == 0 ||
                                  widget.map["Rpt_MultiDt"] == 1
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
                                      padding: const EdgeInsets.only(right: 0),
                                      child: Text(
                                        value.fromDate == null
                                            ? value.lastdate.toString()
                                            : value.fromDate.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          widget.map["Rpt_MultiDt"] == 1
                              ? Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          dateFind.selectDateFind(
                                              context, "to date");
                                        },
                                        icon: Icon(Icons.calendar_month)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        value.todate == null
                                            ? value.lastdate.toString()
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
                                  primary: Color.fromARGB(255, 48, 4, 243),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(2), // <-- Radius
                                  ),
                                ),
                                onPressed: () {
                                  String df;
                                  String tf;

                                  if (value.fromDate == null) {
                                    value.fromDate = value.lastdate.toString();
                                  } else {
                                    value.fromDate = value.fromDate.toString();
                                  }
                                  if (value.todate == null) {
                                    value.todate = value.lastdate.toString();
                                  } else {
                                    value.todate = value.todate.toString();
                                  }
                                  value.getLedger(
                                      context,
                                      value.fromDate.toString(),
                                      value.todate.toString(),
                                      widget.map["Rpt_Script"],
                                      widget.id,
                                      widget.map["Rpt_MultiDt"]);
                                },
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                )),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              value.isLoading
                  ? SpinKitCircle(
                      color: Colors.black,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: value.ledgerWidget.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  child: value.ledgerWidget[index]);
                            }),
                      ),
                    )
              // ListView.builder(
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: value.daybook.length,
              //   shrinkWrap: true,
              //   itemBuilder: (context, index) => Column(
              //     children: [
              //       SizedBox(height: size.height * 0.01),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           const SizedBox(
              //             width: 10,
              //           ),
              //           Text(
              //             value.daybook[index].keys.first,
              //             style: const TextStyle(
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.blue),
              //           ),
              //         ],
              //       ),
              //       Padding(
              //         padding:
              //             const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              //         child: Container(
              //           color: Colors.white,
              //           child: ListView.builder(
              //             shrinkWrap: true,
              //             scrollDirection: Axis.vertical,
              //             physics: ScrollPhysics(),
              //             itemCount: value
              //                 .daybook[index][value.daybook[index].keys.first]
              //                 .length,
              //             itemBuilder: (context, ind) {
              //               List list = value.daybook[index]
              //                   [value.daybook[index].keys.first];
              //               return Container(
              //                   height: size.height * 0.1,
              //                   child: ListTile(
              //                     title: Text(
              //                       list[ind]["Head"],
              //                       style: const TextStyle(
              //                           fontWeight: FontWeight.bold,
              //                           fontSize: 14,
              //                           color: Colors.grey),
              //                     ),
              //                     subtitle: Text(list[ind]["Narraion"]),
              //                     trailing: Text(
              //                       list[ind]["Amount"].toString(),
              //                       style: TextStyle(
              //                           fontWeight: FontWeight.bold,
              //                           color: list[ind]["Amount"] < 0
              //                               ? Colors.red
              //                               : Colors.green),
              //                     ),
              //                   ));
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
    );
  }
}
