import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Providers/NetworkModel.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/NavigatorProgressModuleFinal.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class NavCountDownModalFinal extends StatefulWidget {
  const NavCountDownModalFinal({Key? key}) : super(key: key);

  @override
  State<NavCountDownModalFinal> createState() => _NavCountDownModalFinalState();
}

class _NavCountDownModalFinalState extends State<NavCountDownModalFinal> {
  late NetworkModel _networkProvider;

  late String countDownPopup;

  @override
  Widget build(BuildContext context) {
    final CountdownController controller =
    CountdownController(autoStart: true);

    _networkProvider = Provider.of<NetworkModel>(context, listen: false);

    if (_networkProvider.serviceState == 0) {
      countDownPopup = 'assets/screens/Shipping/koriZFinalShipCountdown.png';
    } else if (_networkProvider.serviceState == 1) {
      countDownPopup = 'assets/screens/Serving/koriZFinalServCountDown.png';
    } else if (_networkProvider.serviceState == 2) {
      countDownPopup =
      'assets/screens/Hotel/BellBoy/koriZFinalBellCountDown.png';
    } else if (_networkProvider.serviceState == 3) {
      countDownPopup =
      'assets/screens/Hotel/RoomService/koriZFinalRoomCountDown.png';
    }

    return Container(
        padding: const EdgeInsets.only(top: 607),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(children: [
            Container(
              width: 740,
              height: 362,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(countDownPopup), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(130, 10, 0, 0),
                child: Countdown(
                  controller: controller,
                  seconds: 5,
                  build: (_, double time) => Text(
                    time.toInt().toString(),
                    style: const TextStyle(
                        fontFamily: 'kor',
                        fontSize: 80,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  interval: const Duration(seconds: 1),
                  onFinished: () {
                    navPage(
                        context: context,
                        page: const NavigatorProgressModuleFinal(),
                        enablePop: false)
                        .navPageToPage();
                  },
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 242,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    fixedSize: const Size(370, 120)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: null,
              ),
            ),
            Positioned(
              left: 370,
              top: 242,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    fixedSize: const Size(370, 120)),
                onPressed: () {
                  navPage(
                      context: context,
                      page: const NavigatorProgressModuleFinal(),
                      enablePop: false)
                      .navPageToPage();
                },
                child: null,
              ),
            ),
          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
