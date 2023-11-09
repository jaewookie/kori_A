import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Debug/test_api_feedback/testPages.dart';
import 'package:kori_wis_demo/Modals/ServiceSelectModal.dart';
import 'package:kori_wis_demo/Modals/ServingModules/returnDishTableSelectModal.dart';
import 'package:kori_wis_demo/Modals/adminPWModal.dart';
import 'package:kori_wis_demo/Modals/powerOffModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/IntroScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigationPatrol.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview2.dart';
import 'package:kori_wis_demo/Screens/Services/WebviewPage/Webview3.dart';
import 'package:kori_wis_demo/Utills/callApi.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigDrawerMenu extends StatefulWidget {
  const ConfigDrawerMenu({Key? key}) : super(key: key);

  @override
  State<ConfigDrawerMenu> createState() => _ConfigDrawerMenuState();
}

class _ConfigDrawerMenuState extends State<ConfigDrawerMenu> {
  late NetworkModel _networkProvider;
  late MainStatusModel _mainStatusProvider;

  final TextEditingController configController = TextEditingController();
  final TextEditingController autoChargeController = TextEditingController();
  late SharedPreferences _prefs;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  dynamic newPoseData;
  dynamic poseData;

  late List<String> positioningList;
  late List<String> positionList;

  late int autoChargeConfig;

  late bool _debugTray;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initSharedPreferences();

    _debugTray = Provider.of<MainStatusModel>(context, listen: false).debugMode!;

    positioningList = [];
    positionList = [];

    autoChargeConfig =
    Provider.of<MainStatusModel>(context, listen: false).autoCharge!;

    startUrl = Provider.of<NetworkModel>(context, listen: false).startUrl;
    navUrl = Provider.of<NetworkModel>(context, listen: false).navUrl;
    chgUrl = Provider.of<NetworkModel>(context, listen: false).chgUrl;

    _initAudio();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _initAudio() {
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  dynamic getting(String hostUrl, String endUrl) async {
    String hostIP = hostUrl;
    String endPoint = endUrl;

    String apiAddress = hostIP + endPoint;

    NetworkGet network = NetworkGet(apiAddress);

    dynamic getApiData = await network.getAPI();

    Provider.of<NetworkModel>(context, listen: false).getApiData = getApiData;

    setState(() {
      positionList = [];
      poseDataUpdate();
    });
  }

  void poseDataUpdate() {
    newPoseData = Provider.of<NetworkModel>(context, listen: false).getApiData;
    if (newPoseData != null) {
      poseData = newPoseData;
      String editPoseData = poseData.toString();

      editPoseData = editPoseData.replaceAll('{', "");
      editPoseData = editPoseData.replaceAll('}', "");
      List<String> positionWithCordList = editPoseData.split("], ");

      for (int i = 0; i < positionWithCordList.length; i++) {
        positioningList = positionWithCordList[i].split(":");
        for (int j = 0; j < positioningList.length; j++) {
          if (j == 0) {
            if (!positioningList[j].contains('[')) {
              poseData = positioningList[j];
              positionList.add(poseData);
            }
          }
        }
      }
      positionList.sort();
    } else {
      positionList = [];
    }
  }

  void showPowerOffPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const PowerOffModalFinal();
        });
  }

  void serviceSelectPopup(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const ServiceSelectModalFinal();
        });
  }

  void showReturnSelectPopup(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ReturnDishTableModal();
        });
  }

  void enterAdmin(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const AdminPWModal();
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    _debugTray = _mainStatusProvider.debugMode!;

    return Drawer(
      backgroundColor: const Color(0xff292929),
      shadowColor: const Color(0xff191919),
      width: 800,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.only(top: 100, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 390,
                    height: 500,
                    child: Column(
                      children: [
                        //ip 변경
                        ExpansionTile(
                            title: const Row(
                              children: [
                                Icon(Icons.track_changes,
                                    color: Colors.white, size: 50),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'IP 변경',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: 'kor',
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            initiallyExpanded: false,
                            backgroundColor: Colors.transparent,
                            onExpansionChanged: (value) {
                              _effectPlayer
                                  .seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                            },
                            children: <Widget>[
                              const Divider(
                                  height: 20,
                                  color: Colors.grey,
                                  indent: 15),
                              SizedBox(
                                width: 390,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50, bottom: 30),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '기존 IP',
                                            style: TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 30,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            startUrl!,
                                            style: const TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '변경 할 IP',
                                            style: TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 30,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 120,
                                          ),
                                          FilledButton(
                                            onPressed: () async {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                      (_) {
                                                    _effectPlayer.seek(
                                                        const Duration(
                                                            seconds: 0));
                                                    _effectPlayer.play();
                                                    _prefs.setString('robotIp',
                                                        configController.text);
                                                    setState(() {
                                                      _networkProvider
                                                          .startUrl =
                                                      "http://${configController.text}/";
                                                      startUrl =
                                                          _networkProvider
                                                              .startUrl;
                                                      configController.text =
                                                      '';
                                                    });
                                                    getting(
                                                        _networkProvider
                                                            .startUrl!,
                                                        _networkProvider
                                                            .positionURL);
                                                  });
                                              FocusScope.of(context).unfocus();
                                              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                                                  overlays: []);
                                            },
                                            style: FilledButton.styleFrom(
                                                enableFeedback: false,
                                                backgroundColor:
                                                const Color.fromRGBO(
                                                    80, 80, 255, 0.7),
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      15),
                                                )),
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextField(
                                        onTap: () {
                                          setState(() {
                                            configController.text = '';
                                          });
                                        },
                                        controller: configController,
                                        style: const TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 25,
                                            color: Colors.white),
                                        keyboardType: TextInputType.url,
                                        decoration: const InputDecoration(
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1),
                                            ),
                                            enabledBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: FilledButton(
                              onPressed: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _effectPlayer
                                      .seek(const Duration(seconds: 0));
                                  _effectPlayer.play();
                                  _networkProvider.servTable = 'wait';
                                  PostApi(
                                      url: startUrl,
                                      endadr: navUrl,
                                      keyBody: 'wait')
                                      .Posting(context);
                                  _networkProvider.currentGoal = '대기장소';
                                  Future.delayed(
                                      const Duration(milliseconds: 230), () {
                                    _effectPlayer.dispose();
                                    navPage(
                                      context: context,
                                      page:
                                      const NavigatorProgressModuleFinal(),
                                    ).navPageToPage();
                                  });
                                });
                              },
                              style: FilledButton.styleFrom(
                                  enableFeedback: false,
                                  backgroundColor: Colors.transparent,
                                  fixedSize: const Size(390, 58),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(0))),
                              child: const Row(
                                children: [
                                  Icon(Icons.add_to_home_screen,
                                      color: Colors.white, size: 50),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      '대기장소로 이동',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        //골포지션 새로고침
                        Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: FilledButton(
                              onPressed: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _effectPlayer
                                      .seek(const Duration(seconds: 0));
                                  _effectPlayer.play();
                                  getting(_networkProvider.startUrl!,
                                      _networkProvider.positionURL);
                                });
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  enableFeedback: false,
                                  fixedSize: const Size(390, 58),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(0))),
                              child: const Row(
                                children: [
                                  Icon(Icons.sync,
                                      color: Colors.white, size: 50),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      '목적지 초기화',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 390,
                    height: 500,
                    child: Column(
                      children: [
                        ExpansionTile(
                            title: const Row(
                              children: [
                                Icon(Icons.battery_saver,
                                    color: Colors.white, size: 50),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    '자동 충전 설정',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: 'kor',
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            initiallyExpanded: false,
                            backgroundColor: Colors.transparent,
                            onExpansionChanged: (value) {
                              _effectPlayer
                                  .seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                            },
                            children: <Widget>[
                              const Divider(
                                  height: 20,
                                  color: Colors.grey,
                                  indent: 15),
                              SizedBox(
                                width: 390,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50, bottom: 30),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '현재 설정',
                                            style: TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 30,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$autoChargeConfig',
                                            style: const TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '변경 할 설정',
                                            style: TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 30,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 120,
                                          ),
                                          FilledButton(
                                            onPressed: () async {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                      (_) {
                                                    _effectPlayer.seek(
                                                        const Duration(
                                                            seconds: 0));
                                                    _effectPlayer.play();
                                                    _prefs.setInt(
                                                        'autoCharge',
                                                        int.parse(
                                                            autoChargeController
                                                                .text));

                                                    setState(() {
                                                      _mainStatusProvider
                                                          .autoCharge =
                                                          int.parse(
                                                              autoChargeController
                                                                  .text);
                                                      autoChargeConfig =
                                                      _mainStatusProvider
                                                          .autoCharge!;
                                                      autoChargeController
                                                          .text = '';
                                                    });
                                                  });
                                              FocusScope.of(context).unfocus();
                                              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                                                  overlays: []);
                                            },
                                            style: FilledButton.styleFrom(
                                                enableFeedback: false,
                                                backgroundColor:
                                                const Color.fromRGBO(
                                                    80, 80, 255, 0.7),
                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      15),
                                                )),
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextField(
                                        onTap: () {
                                          setState(() {
                                            autoChargeController.text = '';
                                          });
                                        },
                                        controller: autoChargeController,
                                        style: const TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 25,
                                            color: Colors.white),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                        decoration: const InputDecoration(
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1),
                                            ),
                                            enabledBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: FilledButton(
                              onPressed: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _effectPlayer
                                      .seek(const Duration(seconds: 0));
                                  _effectPlayer.play();
                                  _networkProvider.servTable =
                                  'charging_pile';
                                  PostApi(
                                      url: startUrl,
                                      endadr: chgUrl,
                                      keyBody: 'charging_pile')
                                      .Posting(context);
                                  _networkProvider.currentGoal = '충전스테이션';
                                  Future.delayed(
                                      const Duration(milliseconds: 230), () {
                                    _effectPlayer.dispose();
                                    navPage(
                                      context: context,
                                      page:
                                      const NavigatorProgressModuleFinal(),
                                    ).navPageToPage();
                                  });
                                });
                              },
                              style: FilledButton.styleFrom(
                                  enableFeedback: false,
                                  backgroundColor: Colors.transparent,
                                  fixedSize: const Size(390, 58),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(0))),
                              child: const Row(
                                children: [
                                  Icon(Icons.ev_station_outlined,
                                      color: Colors.white, size: 50),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      '충전',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        //골포지션 새로고침
                        Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: FilledButton(
                              onPressed: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _effectPlayer
                                      .seek(const Duration(seconds: 0));
                                  _effectPlayer.play();
                                  serviceSelectPopup(context);
                                });
                              },
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  enableFeedback: false,
                                  fixedSize: const Size(390, 58),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(0))),
                              child: const Row(
                                children: [
                                  Icon(Icons.change_circle_outlined,
                                      color: Colors.white, size: 50),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      '서비스 모드 변경',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Offstage(
                offstage: _debugTray,
                child: Column(
                  children: [
                    const Divider(
                      thickness: 5,
                      height: 80,
                      color: Colors.grey,
                      indent: 15,
                      endIndent: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 390,
                          height: 250,
                          child: Column(
                            children: [
                              FilledButton(
                                onPressed: () async {

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer.seek(
                                        const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    _prefs.clear();
                                    Future.delayed(
                                        const Duration(milliseconds: 230),
                                            () {
                                          _effectPlayer.dispose();
                                          navPage(
                                            context: context,
                                            page: const IntroScreen(),
                                          ).navPageToPage();
                                        });
                                    setState(() {
                                      _networkProvider.getApiData =
                                      [];
                                      _networkProvider.startUrl = "";
                                    });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    enableFeedback: false,
                                    backgroundColor:
                                    Colors.transparent,
                                    fixedSize: const Size(390, 58),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            0))),
                                child: const Row(
                                  children: [
                                    Icon(Icons.autorenew,
                                        color: Colors.white,
                                        size: 50),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(left: 15),
                                      child: Text(
                                        '기본정보 초기화',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 36,
                                            fontWeight:
                                            FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FilledButton(
                                onPressed: () {

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer.seek(
                                        const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    Future.delayed(
                                        const Duration(milliseconds: 230),
                                            () {
                                          _effectPlayer.dispose();
                                          navPage(
                                            context: context,
                                            page:
                                            const NavigationPatrol(),
                                          ).navPageToPage();
                                        });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    enableFeedback: false,
                                    backgroundColor:
                                    Colors.transparent,
                                    fixedSize: const Size(390, 58),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            0))),
                                child: const Row(
                                  children: [
                                    Icon(Icons.repeat,
                                        color: Colors.white,
                                        size: 50),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(left: 15),
                                      child: Text(
                                        '순찰 기동',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 36,
                                            fontWeight:
                                            FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 390,
                          height: 250,
                          child: Column(
                            children: [
                              FilledButton(
                                onPressed: () {

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer.play();
                                    _effectPlayer.seek(
                                        const Duration(seconds: 0));
                                    Future.delayed(
                                        const Duration(milliseconds: 230),
                                            () {
                                          _effectPlayer.dispose();
                                          navPage(
                                            context: context,
                                            page: const TestPagesScreen(),
                                          ).navPageToPage();
                                        });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    enableFeedback: false,
                                    backgroundColor:
                                    Colors.transparent,
                                    fixedSize: const Size(390, 58),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            0))),
                                child: const Row(
                                  children: [
                                    Icon(Icons.request_page,
                                        color: Colors.white,
                                        size: 50),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(left: 15),
                                      child: Text(
                                        '테스트 페이지 이동',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 36,
                                            fontWeight:
                                            FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FilledButton(
                                onPressed: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _effectPlayer.seek(
                                        const Duration(seconds: 0));
                                    _effectPlayer.play();
                                    Future.delayed(
                                        const Duration(milliseconds: 230),
                                            () {
                                          _effectPlayer.dispose();
                                          navPage(
                                            context: context,
                                            page: const IntroScreen(),
                                          ).navPageToPage();
                                        });
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    enableFeedback: false,
                                    backgroundColor:
                                    Colors.transparent,
                                    fixedSize: const Size(390, 58),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            0))),
                                child: const Row(
                                  children: [
                                    Icon(Icons.repeat,
                                        color: Colors.white,
                                        size: 50),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(left: 15),
                                      child: Text(
                                        '인트로 화면 이동',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 36,
                                            fontWeight:
                                            FontWeight.bold,
                                            height: 1.2,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 5,
                      height: 80,
                      color: Colors.grey,
                      indent: 15,
                      endIndent: 15,
                    ),
                    const Text(
                      '액티브 링크',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'kor',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              Future.delayed(const Duration(milliseconds: 230), () {
                                _effectPlayer.dispose();
                                navPage(
                                  context: context,
                                  page: const WebviewPage1(),
                                ).navPageToPage();
                              });
                            });
                          },
                          style: TextButton.styleFrom(
                              fixedSize: const Size(60, 60),
                              enableFeedback: false,
                              padding: const EdgeInsets.only(right: 0, bottom: 2),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(0))),
                          child: const Text(
                            '1',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 40,
                                color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              Future.delayed(const Duration(milliseconds: 230), () {
                                _effectPlayer.dispose();
                                navPage(
                                  context: context,
                                  page: const WebviewPage2(),
                                ).navPageToPage();
                              });
                            });
                          },
                          style: TextButton.styleFrom(
                              fixedSize: const Size(60, 60),
                              enableFeedback: false,
                              padding: const EdgeInsets.only(right: 0, bottom: 2),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(0))),
                          child: const Text(
                            '2',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 40,
                                color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              Future.delayed(const Duration(milliseconds: 230), () {
                                _effectPlayer.dispose();
                                navPage(
                                  context: context,
                                  page: const WebviewPage3(),
                                ).navPageToPage();
                              });
                            });
                          },
                          style: TextButton.styleFrom(
                              fixedSize: const Size(60, 60),
                              enableFeedback: false,
                              padding: const EdgeInsets.only(right: 0, bottom: 2),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(0))),
                          child: const Text(
                            '3',
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 40,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 800,
                child: FilledButton(
                  onPressed: () {
                    if(_debugTray == true){
                      enterAdmin(context);
                    }else{
                      setState(() {
                        _mainStatusProvider.debugMode = true;
                      });
                    }
                  },
                  style: FilledButton.styleFrom(
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(0),
                      ),
                      fixedSize: const Size(400, 150)),
                  child: Text('관리자 모드', style: TextStyle(
                      fontSize: 50,
                      color: _debugTray==true ? Colors.white : Colors.red
                  ),),
                ),
              ),
            ],
          ),
        ),
        //전원 버튼
        Container(
          margin: EdgeInsets.only(left: 700, top: 10),
          width: 78,
          child: IconButton(
            onPressed: () {
              showPowerOffPopup(context);
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            iconSize: 60,
          ),
        ),
      ]),
    );
  }
}
