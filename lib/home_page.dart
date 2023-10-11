import 'package:flutter/material.dart';
import 'package:trafiqpro/report_title_page.dart';

import 'dahsboard_report_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Company Name"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.07,
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Branch"),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/left.png",
                        height: size.height * 0.022,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Text("Date"),
                      ),
                      Image.asset(
                        "assets/right.png",
                        height: size.height * 0.022,
                      ),
                    ],
                  )
                ],
              ),
            ),
            DashboardReport(),
            ReportTabs()
          ],
        ),
      ),
    );
  }
}
