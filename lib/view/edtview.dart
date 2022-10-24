import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:path_provider/path_provider.dart';

class EdtView extends StatelessWidget {
  EdtView({super.key});

  final dio = Dio();
  late double width;
  late double height;

  @override
  Widget build(context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    print(width);

    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return Center(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Container (
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: nightSwitcherState.container,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: nightSwitcherState.container,
                        style: TextStyle(
                            color: nightSwitcherState.textInContainer,
                            fontWeight: FontWeight.bold
                        ),
                        borderRadius: BorderRadius.circular(8),
                        icon: Container(),
                        underline: Container(),
                        value: "Monday",
                        items: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"].map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.arrow_forward),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: (height * 0.764) / 10,
                child: Row(
                  children: [
                   Container(
                     margin: EdgeInsets.symmetric(horizontal: width * 0.1),
                     child: const Text(
                       "location",
                     )
                   ),
                    const Expanded(
                      child: Text(
                        "summary",
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// Container test
/*Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: nightSwitcherState.container,
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextButton(
              onPressed: () async {
                /*
                var res = await dio.post(
                  "https://ade6-usmb-ro.grenet.fr/jsp/custom/modules/plannings/direct_cal.jsp",
                  queryParameters: {
                    "data": "1b9e1ac2a1720dfd6bd1d42ad86c77f9c55ef35a53135e0070a97be8b09957efa9a0e9cb08b4730b",
                    "resources": 2663,
                    "projectId": 4,
                    "calType": "ical",
                    "lastDate": "2040-08-14"
                  }
                );
                * */
                var str = await File("/data/user/0/fr.HirooDebug.homeworkbloc/files/edt.ics").readAsString();

                final cal = ICalendar.fromString(str);
                var a = cal.data[2];

                var dtstart = (a["dtstart"] as IcsDateTime).dt;
                var dtend = (a["dtend"] as IcsDateTime).dt;

                var yearStart = dtstart.substring(0, 4);
                var yearEnd = dtend.substring(0, 4);

                var monthStart = dtstart.substring(4, 6);
                var monthEnd = dtend.substring(4, 6);

                var dayStart = dtstart.substring(6, 8);
                var dayEnd = dtend.substring(6, 8);

                print(dtstart);
                print(dtend);
              },
              child: Text(
                "Test",
                style: TextStyle(
                  color: nightSwitcherState.textInContainer,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
* */

//Command post
//curl -K file.ics -X POST
// "https://ade6-usmb-ro.grenet.fr/jsp/custom/modules/plannings/direct_cal.jsp
// ?data=1b9e1ac2a1720dfd6bd1d42ad86c77f9c55ef35a53135e0070a97be8b09957efa9a0e9cb08b4730b
// &resources=2663
// &projectId=4
// &calType=ical
// &lastDate=2040-08-14" > edt.ics
