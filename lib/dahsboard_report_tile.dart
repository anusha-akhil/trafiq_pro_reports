import 'package:flutter/material.dart';

class DashboardReport extends StatefulWidget {
  const DashboardReport({super.key});

  @override
  State<DashboardReport> createState() => _DashboardReportState();
}

class _DashboardReportState extends State<DashboardReport> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height * 0.17,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Color.fromARGB(255, 252, 158, 223),
                  height: size.height * 0.05,
                  width: size.width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Report $index"), Text("120.00")],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: size.height * 0.17,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Cash"),
                          Text("1200"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Credit"),
                          Text("1200"),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Cash"),
                          Text("1200"),
                        ],
                      )
                    ],
                  ),
                  color: Color.fromARGB(255, 238, 224, 101),
                  height: size.height * 0.05,
                  width: size.width * 0.9,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
