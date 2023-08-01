import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/getPowerInform.dart';

import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';

class PatrolProgress extends StatefulWidget {
  final String patrol1;
  final String patrol2;

  const PatrolProgress({
    required this.patrol1,
    required this.patrol2,
    Key? key,
  }) : super(key: key);

  @override
  State<PatrolProgress> createState() => _PatrolProgressState();
}

class _PatrolProgressState extends State<PatrolProgress> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;

  late Timer _pwrTimer;
  late String backgroundImageServ;

  late String targetPoint1;
  late String targetPoint2;

  late String targetPoint;

  late bool patrolling;

  late bool arrivedServingTable;

  String? startUrl;
  String? navUrl;
  String? stpUrl;

  late int batData;
  late int CHGFlag;
  late int EMGStatus;

  String? moveBaseStatusUrl;

  late int navStatus;

  late bool initNavStatus;

  late int stopDuration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNavStatus = true;
    navStatus = 0;
    arrivedServingTable = false;

    targetPoint1 = widget.patrol1;
    targetPoint2 = widget.patrol2;

    targetPoint = targetPoint1;

    patrolling = true;

    stopDuration=0;

    batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
    CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
    EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;

    _pwrTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      StatusManagements(context,
          Provider.of<NetworkModel>(context, listen: false).startUrl!)
          .gettingPWRdata();
      if (EMGStatus !=
          Provider.of<MainStatusModel>(context, listen: false).emgButton!) {
        setState(() {});
      }
      if (batData !=
          Provider.of<MainStatusModel>(context, listen: false).batBal!) {
        setState(() {});
      }
      batData = Provider.of<MainStatusModel>(context, listen: false).batBal!;
      CHGFlag = Provider.of<MainStatusModel>(context, listen: false).chargeFlag!;
      EMGStatus = Provider.of<MainStatusModel>(context, listen: false).emgButton!;
    });
  }

  Future<dynamic> Getting(String hostUrl, String endUrl) async {
    final apiAdr = hostUrl + endUrl;

    NetworkGet network = NetworkGet(apiAdr);

    dynamic getApiData = await network.getAPI();

    if (initNavStatus == true) {
      if (getApiData == 3) {
        while (getApiData != 3) {
          if (mounted) {
            Provider.of<NetworkModel>((context), listen: false).APIGetData =
                getApiData;
            setState(() {
              navStatus = Provider.of<NetworkModel>((context), listen: false)
                  .APIGetData['status'];
              initNavStatus = false;
            });
          }
        }
      } else {
        if (mounted) {
          Provider.of<NetworkModel>((context), listen: false).APIGetData =
              getApiData;
          setState(() {
            navStatus = Provider.of<NetworkModel>((context), listen: false)
                .APIGetData['status'];
            initNavStatus = false;
          });
        }
      }
    } else {
      if (mounted) {
        Provider.of<NetworkModel>((context), listen: false).APIGetData =
            getApiData;
        setState(() {
          navStatus = Provider.of<NetworkModel>((context), listen: false)
              .APIGetData['status'];
          initNavStatus = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pwrTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    stpUrl = _networkProvider.stpUrl;
    moveBaseStatusUrl = _networkProvider.moveBaseStatusUrl;

    backgroundImageServ = "assets/screens/Nav/koriZFinalServProgNav.png";

    if (patrolling == true) {
      // print('a');
      PostApi(url: startUrl, endadr: navUrl, keyBody: targetPoint)
          .Posting(context);
      setState(() {
        patrolling = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Getting(startUrl!, moveBaseStatusUrl!);
      });
      if (navStatus == 3 && arrivedServingTable == false) {
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            patrolling = true;
            arrivedServingTable = true;
            navStatus = 0;
          });
        });
        if (targetPoint == targetPoint1) {
          Future.delayed(Duration(seconds: 5), () {
            setState(() {
              arrivedServingTable = false;
              targetPoint = targetPoint2;
            });
          });
        } else if (targetPoint == targetPoint2) {
          Future.delayed(Duration(seconds: 5), () {
            setState(() {
              arrivedServingTable = false;
              targetPoint = targetPoint1;
            });
          });
        }
      }
    });

    double screenWidth = 1080;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              width: screenWidth,
              height: 108,
              child: Stack(
                children: [
                  Positioned(
                    right: 46,
                    top: 60,
                    child: Text(('${batData.toString()} %')),
                  ),
                  Positioned(
                    right: 50,
                    top: 20,
                    child: Container(
                      height: 45,
                      width: 50,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/icons/appBar/appBar_Battery.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  EMGStatus == 0
                      ? const Positioned(
                    right: 35,
                    top: 15,
                    child: Icon(Icons.block,
                        color: Colors.red,
                        size: 80,
                        grade: 200,
                        weight: 200),
                  )
                      : Container(),
                ],
              ),
            )
          ],
          toolbarHeight: 110,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImageServ), fit: BoxFit.cover)),
            child: Stack(
              children: [
                Positioned(
                  top: 500,
                  left: 0,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _servingProvider.mainInit = true;
                        });
                        PostApi(url: startUrl, endadr: stpUrl, keyBody: 'stop')
                            .Posting(context);
                        Future.delayed(Duration(milliseconds: 20), (){
                          PostApi(url: startUrl, endadr: navUrl, keyBody: 'wait')
                              .Posting(context);
                        });
                        navPage(context: context, page: TraySelectionFinal()).navPageToPage();
                      },
                      child: Container(
                          height: 800,
                          width: 1080,
                          decoration: const BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(
                                  color: Colors.transparent, width: 1))))),
                ),
                Positioned(
                    top: 372,
                    left: 460,
                    child: Container(
                      width: 300,
                      height: 90,
                      child: Text(
                        '${targetPoint}번 테이블',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontFamily: 'kor',
                            fontSize: 55,
                            color: Color(0xfffffefe)),
                      ),
                    )),
                Positioned(
                    top: 1367,
                    left: 107,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _servingProvider.mainInit = true;
                        });
                        PostApi(url: startUrl, endadr: stpUrl, keyBody: 'stop')
                            .Posting(context);
                        Future.delayed(Duration(milliseconds: 20), (){
                          PostApi(url: startUrl, endadr: navUrl, keyBody: 'wait')
                              .Posting(context);
                        });
                        navPage(context: context, page: TraySelectionFinal()).navPageToPage();
                      },
                      child: null,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                        ),
                        fixedSize: Size(866, 173)
                      ),
                    ))
                // NavModuleButtonsFinal(
                //   screens: 0,
                //   servGoalPose: servTableNum,
                // )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}