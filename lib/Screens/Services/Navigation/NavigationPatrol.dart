import 'package:flutter/material.dart';
import 'package:kori_wis_demo/Screens/Services/Navigation/PatrolProg.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarAction.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';

class NavigationPatrol extends StatefulWidget {
  const NavigationPatrol({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationPatrol> createState() => _NavigationPatrolState();
}

class _NavigationPatrolState extends State<NavigationPatrol> {

  late List<double> buttonPositionWidth;
  late List<double> buttonPositionHeight;
  late List<double> buttonSize;

  late double buttonRadius;

  late int buttonNumbers;

  late String patrolPoints1;
  late String patrolPoints2;

  int buttonWidth = 0;
  int buttonHeight = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    patrolPoints1 = '';
    patrolPoints2 = '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = 1080;

    buttonPositionWidth = [205, 205, 205, 205, 585, 585, 585, 585];
    buttonPositionHeight = [
      245.5,
      565.6,
      870.7,
      1178,
      245.5,
      565.6,
      870.7,
      1178
    ];

    buttonSize = [208, 118];

    buttonRadius = 0;

    buttonNumbers = buttonPositionHeight.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: screenWidth,
            height: 108,
            child: const Stack(
              children: [
                AppBarStatus(),
                AppBarAction(homeButton: true,)
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
          color: const Color(0xff191919),
          child: Stack(
            children: [
              Container(
                width: 1080,
                height: 170,
                margin: const EdgeInsets.only(top: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            patrolPoints1 = '';
                          });
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(220, 150),
                            side: const BorderSide(
                                color: Colors.white, width: 1)),
                        child: Text(
                          patrolPoints1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontFamily: 'kor'),
                        )),
                    const SizedBox(
                        width: 120,
                        height: 120,
                        child: Icon(
                          Icons.repeat,
                          color: Colors.white,
                          size: 120,
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            patrolPoints2 = '';
                          });
                        },
                        style: TextButton.styleFrom(
                            fixedSize: const Size(220, 150),
                            side: const BorderSide(
                                color: Colors.white, width: 1)),
                        child: Text(
                          patrolPoints2,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontFamily: 'kor'),
                        ))
                  ],
                ),
              ),
              Container(
                height: 330,
                width: 1080,
                margin: const EdgeInsets.only(top: 370),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        navPage(
                                context: context,
                                page: PatrolProgress(
                                    patrol1: patrolPoints1,
                                    patrol2: patrolPoints2))
                            .navPageToPage();
                      },
                      style: TextButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 1),
                          backgroundColor: Colors.blue,
                          shape: const RoundedRectangleBorder(),
                          fixedSize: const Size(220, 150)),
                      child: const Text(
                        '출발',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'kor',
                            fontSize: 70),
                      ),
                    )
                  ],
                ),
              ),
              for (int i = 0; i < buttonNumbers; i++)
                Container(
                  margin: const EdgeInsets.only(top: 700),
                  padding: const EdgeInsets.only(bottom: 250, top: 10),
                  height: 1220,
                  width: 1080,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int j = 0; j < (buttonNumbers / 2); j++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int h = 0; h < 2; h++)
                              FilledButton(
                                  onPressed: () {
                                    if (patrolPoints1 == '') {
                                      setState(() {
                                        patrolPoints1 = '${2 * j + h + 1}';
                                      });
                                    } else if (patrolPoints2 == '') {
                                      setState(() {
                                        patrolPoints2 = '${2 * j + h + 1}';
                                      });
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.white, width: 2),
                                          borderRadius: BorderRadius.circular(
                                              buttonRadius)),
                                      fixedSize: Size(buttonSize[buttonWidth],
                                          buttonSize[buttonHeight])),
                                  child: Text(
                                    '${2 * j + h + 1} 번',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'kor',
                                        fontSize: 40),
                                  ))
                          ],
                        )
                    ],
                  ),
                )
            ],
          ),
        ),
      ]),
    );
  }
}
