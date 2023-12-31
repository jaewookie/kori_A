import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Providers/ServingModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/FacilityNav.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Screens/Services/Serving/TraySelectionFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Utills/postAPI.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class NavCountDownModalFinal extends StatefulWidget {
  final String? goalPosition;
  final String? serviceMode;

  const NavCountDownModalFinal({Key? key, this.goalPosition, this.serviceMode})
      : super(key: key);

  @override
  State<NavCountDownModalFinal> createState() => _NavCountDownModalFinalState();
}

class _NavCountDownModalFinalState extends State<NavCountDownModalFinal> {
  late NetworkModel _networkProvider;
  late ServingModel _servingProvider;
  late MainStatusModel _mainStatusProvider;

  final CountdownController _controller = CountdownController(autoStart: true);

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';
  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/koriServingNavBegin.wav';

  String? currentGoal;

  String? startUrl;
  String? navUrl;
  String? chgUrl;

  late int tableQT;

  late bool countDownNav;

  late String targetTableNum;

  bool? goalChecker;

  late bool apiCallFlag;

  late String countDownModalBtn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentGoal = "";
    goalChecker = false;
    tableQT = 8;
    apiCallFlag = false;
    countDownNav = true;

    _initAudio();
  }

  void _initAudio() {
    AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _networkProvider = Provider.of<NetworkModel>(context, listen: false);
    _servingProvider = Provider.of<ServingModel>(context, listen: false);
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    startUrl = _networkProvider.startUrl;
    navUrl = _networkProvider.navUrl;
    chgUrl = _networkProvider.chgUrl;

    countDownModalBtn = 'assets/images/modalIMG/btn.png';

    if (widget.serviceMode == 'Serving') {
      if (_servingProvider.trayCheckAll == true) {
        targetTableNum = _servingProvider.allTable!;
      } else {
        if (_servingProvider.table1 != "") {
          targetTableNum = _servingProvider.table1!;
        } else {
          if (_servingProvider.table2 != "") {
            targetTableNum = _servingProvider.table2!;
          } else {
            if (_servingProvider.table3 != "") {
              targetTableNum = _servingProvider.table3!;
            }
          }
        }
      }
      _servingProvider.targetTableNum = targetTableNum;
    } else {
      targetTableNum = widget.goalPosition!;
    }

    return Container(
        padding: const EdgeInsets.only(top: 144),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(children: [
            Container(
              width: 738,
              height: 441,
              decoration: BoxDecoration(
                  border: const Border.fromBorderSide(
                      BorderSide(color: Color(0x4cffffff), width: 0.5)),
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                      colors: [Color(0xff4e4e4e), Color(0xff444444)])),
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 35),
                      height: 320,
                      width: 828,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(6),
                            width: 640,
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Countdown(
                                  controller: _controller,
                                  seconds: 5,
                                  build: (_, double time) => Text(
                                    time.toInt().toString(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        height: 1.2,
                                        fontFamily: 'kor',
                                        fontSize: 65,
                                        color: Colors.white,
                                        letterSpacing: -0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  interval: const Duration(seconds: 1),
                                  onFinished: () {
                                    _audioPlayer.play();
                                    if (widget.serviceMode == 'Shipping' ||
                                        widget.serviceMode == 'facilityGuide') {
                                      _networkProvider.servTable =
                                          widget.goalPosition;
                                    } else {
                                      _servingProvider.trayChange = true;
                                      _networkProvider.servTable =
                                          _servingProvider.targetTableNum;
                                    }
                                    PostApi(
                                            url: startUrl,
                                            endadr: navUrl,
                                            keyBody: targetTableNum)
                                        .Posting(context);
                                    Future.delayed(
                                        const Duration(milliseconds: 230), () {
                                      _audioPlayer.dispose();
                                      _effectPlayer.dispose();
                                      if (widget.serviceMode == 'facilityGuide') {
                                        _mainStatusProvider.facilityArrived = false;
                                        _mainStatusProvider.audioState = true;
                                        navPage(
                                                context: context,
                                                page:
                                                    const FacilityNavigation())
                                            .navPageToPage();
                                      } else {
                                        navPage(
                                          context: context,
                                          page:
                                              const NavigatorProgressModuleFinal(),
                                        ).navPageToPage();
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                _mainStatusProvider.robotServiceMode == 0
                                    ? const Text('초 후 서빙을 시작합니다.',
                                        style: TextStyle(
                                            fontFamily: 'kor',
                                            fontSize: 42,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: -0.04
                                        ))
                                    : _mainStatusProvider.robotServiceMode ==
                                            1
                                        ? const Text('초 후 배송을 시작합니다.',
                                            style: TextStyle(
                                                fontFamily: 'kor',
                                                fontSize: 42,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: -0.04
                                            ))
                                        : _mainStatusProvider
                                                    .robotServiceMode ==
                                                2
                                            ? const Text('초 후 안내를 시작합니다.',
                                                style: TextStyle(
                                                    fontFamily: 'kor',
                                                    fontSize: 42,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: -0.04
                                                ))
                                            : Container(),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Container(
                    width: 684,
                    height: 102,
                    margin: const EdgeInsets.only(top: 312, left: 27),
                    child: Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              enableFeedback: false,
                              foregroundColor: const Color(0xff222222),
                              backgroundColor: const Color(0xb3333333),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(

                              ),
                              fixedSize: const Size(336, 102)),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              _controller.pause();
                              if (_mainStatusProvider.robotServiceMode == 0) {
                                if (_servingProvider.table1 != "" ||
                                    (_servingProvider.table2 != "" ||
                                        _servingProvider.table3 != "")) {
                                  Future.delayed(
                                      const Duration(milliseconds: 230), () {
                                    _audioPlayer.dispose();
                                    _effectPlayer.dispose();
                                    navPage(
                                        context: context,
                                        page: const TraySelectionFinal())
                                        .navPageToPage();
                                  });
                                } else {
                                  Future.delayed(
                                      const Duration(milliseconds: 230), () {
                                    _audioPlayer.dispose();
                                    _effectPlayer.dispose();
                                    navPage(
                                        context: context,
                                        page: const TraySelectionFinal())
                                        .navPageToPage();
                                  });
                                }
                              } else if (_mainStatusProvider
                                  .robotServiceMode ==
                                  2) {
                                Future.delayed(
                                    const Duration(milliseconds: 230), () {
                                  _audioPlayer.dispose();
                                  _effectPlayer.dispose();
                                  navPage(
                                      context: context,
                                      page: const FacilityScreen())
                                      .navPageToPage();
                                });
                              }
                            });
                          },
                          child: const Text(
                            '취소',
                            style: TextStyle(
                                color: Color(0xffffffff),
                                fontFamily: 'kor',
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.03),
                          ),
                        ),
                        const SizedBox(width: 11,),
                        TextButton(
                          style: TextButton.styleFrom(
                              enableFeedback: false,
                              foregroundColor: const Color(0xff222222),
                              backgroundColor: const Color(0xb3333333),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(

                              ),
                              fixedSize: const Size(336, 102)),
                          onPressed: () {
                            _audioPlayer.play();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _effectPlayer.seek(const Duration(seconds: 0));
                              _effectPlayer.play();
                              _controller.pause();
                              if (widget.serviceMode == 'Shipping' ||
                                  widget.serviceMode == 'facilityGuide') {
                                _networkProvider.servTable =
                                    widget.goalPosition;
                              } else {
                                _servingProvider.trayChange = true;
                                _networkProvider.servTable =
                                    _servingProvider.targetTableNum;
                              }
                              PostApi(
                                  url: startUrl,
                                  endadr: navUrl,
                                  keyBody: targetTableNum)
                                  .Posting(context);
                              Future.delayed(
                                  const Duration(milliseconds: 230), () {
                                _audioPlayer.dispose();
                                _effectPlayer.dispose();
                                if (widget.serviceMode == 'facilityGuide') {
                                  _mainStatusProvider.audioState = true;
                                  _mainStatusProvider.facilityArrived = false;
                                  navPage(
                                      context: context,
                                      page: const FacilityNavigation())
                                      .navPageToPage();
                                } else {
                                  navPage(
                                    context: context,
                                    page:
                                    const NavigatorProgressModuleFinal(),
                                  ).navPageToPage();
                                }
                              });
                            });
                          },
                          child: Center(
                            child: Text(
                              '시작',
                              style: TextStyle(
                                  color: const Color(0xffffffff).withOpacity(0.7),
                                  fontFamily: 'kor',
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.03),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
