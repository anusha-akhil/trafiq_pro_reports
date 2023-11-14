import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:trafiqpro/controller/registration_controller.dart';
import 'package:trafiqpro/screen/daybook_report.dart';
import 'package:trafiqpro/screen/report_tabs.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controller/controller.dart';
import 'dahsboard_report_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selected;
  String? todaydate;
  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todaydate = DateFormat('dd-MMM-yyyy').format(now);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false)
          .getBranches(context, );
      Provider.of<Controller>(context, listen: false).getDbName();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // backgroundColor: Colors.white70,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[600],
        elevation: 10,
        centerTitle: false,
        title: Consumer<Controller>(
          builder: (context, value, child) => Text(
            value.cName.toString(),
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Consumer<Controller>(
                builder: (context, value, child) => InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // Provider.of<RegistrationController>(context,
                        //         listen: false)
                        //     .initDb(context, "");
                      },
                      child: value.yr == null
                          ? Container()
                          : Text(
                              value.yr.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<Controller>(
          builder: (context, value, child) => Column(
            children: [
              Container(
                // height: size.height * 0.05,
                // color: Colors.grey[200],
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    value.branch_list.length == 0
                        ? Container()
                        : Container(
                            // width: size.width * 0.45,
                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //       color: Colors.white),
                            //   borderRadius: BorderRadius.circular(28),
                            // ),
                            // width: size.width * 0.4,
                            // height: size.height * 0.04,

                            child: ButtonTheme(
                              // alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: selected,
                                // isDense: true,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 9.0),
                                  child: Text(
                                    value.selected.toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue),
                                  ),
                                ),
                                isExpanded: false,
                                autofocus: false,
                                underline: SizedBox(),
                                elevation: 0,
                                items: value.branch_list
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item["Br_ID"].toString(),
                                        child: Container(
                                          // width: size.width * 0.4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 9.0),
                                            child: Text(
                                              item["Br_Name"].toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        )))
                                    .toList(),
                                onChanged: (item) {
                                  print("clicked");
                                  String? date;
                                  if (item != null) {
                                    if (value.dashDate == null) {
                                      date = todaydate.toString();
                                    } else {
                                      date = value.dashDate.toString();
                                    }
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .setDropdowndata(item.toString(),
                                            date.toString(), context);
                                    print("clicked------$item");
                                  }
                                },
                              ),
                            ),
                          ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0),
                    //   child: Text(
                    //     "Branch",
                    //     style: TextStyle(
                    //         color: Colors.blue, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Provider.of<Controller>(context, listen: false)
                                  .findDate(value.d, "prev", context);
                            },
                            child: Image.asset("assets/left.png",
                                height: size.height * 0.021,
                                color: Colors.yellow),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Text(
                              value.dashDate.toString(),
                              // value.dashDate == null
                              //     ? todaydate.toString()
                              //     : value.dashDate.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Provider.of<Controller>(context, listen: false)
                                  .findDate(value.d, "after", context);
                            },
                            child: Image.asset("assets/right.png",
                                height: size.height * 0.021,
                                color: Colors.yellow),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // Divider(
              //   thickness: 1,
              //   color: Colors.white,
              //   // height: 25,
              // ),
              imageContainer(size),
              value.isLoading
                  ? Center(
                      child: SpinKitCircle(
                      color: Colors.white,
                    ))
                  : DashboardReport(),
              ReportTabs(),
              // AccountReports()
            ],
          ),
        ),
      ),
    );
  }

  Widget imageContainer(Size size) {
    return CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 1,
          height: size.height * 0.25,
          autoPlayInterval: Duration(seconds: 2),
          autoPlay: true),
      items: ["001.png", "002.png", "005.png"].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Image.asset(
                  "assets/$i",
                  fit: BoxFit.fill,
                  width: size.width * 0.95,
                ));
          },
        );
      }).toList(),

      // child: Container(
      //   width: size.width * 0.95,
      //   height: size.height * 0.25,
      //   child: Image.asset(
      //     "assets/graph.jpeg",
      //     fit: BoxFit.cover,
      //   ),
      // ),
    );
  }
}
