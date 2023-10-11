import 'package:flutter/material.dart';

class ReportTabs extends StatefulWidget {
  const ReportTabs({super.key});

  @override
  State<ReportTabs> createState() => _ReportTabsState();
}

class _ReportTabsState extends State<ReportTabs> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              "Sale Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
                    children: [
                      Text("Sale Report $index"),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
