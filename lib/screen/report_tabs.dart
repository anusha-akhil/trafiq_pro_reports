import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trafiqpro/screen/customer_list.dart';
import 'package:trafiqpro/screen/daybook_report.dart';
import '../components/popups/level1_rp_detail.dart';
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
                const SizedBox(
                  width: 10,
                ),
                Text(
                  value.report_tile_val[index].keys.first,
                  style: const TextStyle(
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
                      print("jhjhdsbd------${list[ind]}");

                      if (list[ind]["Stat_Key"] == "DB") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DaybookReports(
                                    map: list[ind],
                                  )),
                        );
                      } else if (list[ind]["Stat_Key"] == "LG") {
                        // value.getCustomerList(context, );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerList(
                                    map: list[ind],
                                  )),
                        );
                      } else {
                        value.getSubReport(context, list[ind]["Rpt_ID"]);
                        value.report_data.clear();
                        value.todate = null;
                        value.fromDate = null;
                        Level1ReportDetails popup = Level1ReportDetails();
                        popup.viewData(
                            context, list[ind], ind, list[ind]["Rpt_Key"]);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: list[ind]["Rpt_Type"] == 2
                                ? const Color.fromARGB(255, 33, 201, 243)
                                : Color.fromARGB(221, 73, 73, 73)),
                        height: size.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                list[ind]["Rpt_Name"],
                                style: const TextStyle(
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
          ],
        ),
      ),
    );
  }
}
