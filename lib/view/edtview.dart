import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:homeworkbloc/modelview/nightswitchercubit.dart';
import 'package:path_provider/path_provider.dart';

class EdtView extends StatelessWidget {
  EdtView({super.key});

  final dio = Dio();

  //curl -K file.ics -X POST
  // "https://ade6-usmb-ro.grenet.fr/jsp/custom/modules/plannings/direct_cal.jsp
  // ?data=1b9e1ac2a1720dfd6bd1d42ad86c77f9c55ef35a53135e0070a97be8b09957efa9a0e9cb08b4730b
  // &resources=2663
  // &projectId=4
  // &calType=ical
  // &lastDate=2040-08-14" > edt.ics

  @override
  Widget build(context) {
    return BlocBuilder<NightSwitcherCubit, NightSwitcherState>(
      builder: (context, nightSwitcherState) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: nightSwitcherState.container,
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextButton(
              onPressed: () async {
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
                try {
                  print(await getApplicationDocumentsDirectory());
                } catch (e, s) {
                  print(s);
                }
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
          ),
        );
      },
    );
  }
}