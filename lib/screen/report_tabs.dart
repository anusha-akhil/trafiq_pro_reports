import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/popups/rp_detail.dart';
import '../controller/controller.dart';

class ReportTabs extends StatefulWidget {
  const ReportTabs({super.key});

  @override
  State<ReportTabs> createState() => _ReportTabsState();
}

class _ReportTabsState extends State<ReportTabs> {
  // List report_tabs = ["sale Report", "Purchase Reports", "Stock Repports"];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<Controller>(
      builder: (context, value, child) => ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: value.report_tile_val.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => Column(
          children: [
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  value.report_tile_val[index].keys.first,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
            Container(
              height: size.height * 0.17,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: value
                    .report_tile_val[index]
                        [value.report_tile_val[index].keys.first]
                    .length,
                itemBuilder: (context, ind) {
                  List list = value.report_tile_val[index]
                      [value.report_tile_val[index].keys.first];
                  return InkWell(
                    onTap: () {
                      value.getReportTabledata(
                          context, list[ind]["Rpt_Script"], "12-2-2013");
                      ReportDetails popup = ReportDetails();
                      popup.viewData(context, list[ind]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(221, 73, 73, 73)
                            //   gradient: LinearGradient(
                            // begin: Alignment.topRight,
                            // end: Alignment.bottomLeft,
                            // colors: [
                            //   Color.fromARGB(255, 90, 89, 89),
                            //   // Colors.white,
                            // ],
                            // )
                            ),
                        height: size.height * 0.05,
                        // width: size.width * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                list[ind]["Rpt_Name"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // SizedBox(height: size.height * 0.01),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Text(
            //       "Purchase Report",
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // ),
            // Container(
            //   height: size.height * 0.17,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     // physics: ScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: 4,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           color: Color.fromARGB(255, 106, 223, 52),
            //           height: size.height * 0.05,
            //           width: size.width * 0.3,
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Flexible(child: Text("Purchase Report $index")),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
