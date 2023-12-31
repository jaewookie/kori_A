import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class EMGPopModalFinal extends StatefulWidget {

  const EMGPopModalFinal({Key? key})
      : super(key: key);

  @override
  State<EMGPopModalFinal> createState() =>
      _EMGPopModalFinalState();
}

class _EMGPopModalFinalState
    extends State<EMGPopModalFinal> {
  late String countDownPopup;

  late AudioPlayer _audioPlayer;
  final String _audioFile = 'assets/voices/koriServingEMGButton.wav';
  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  late String countDownModalBg;
  late String countDownModalBtn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();
    _audioPlayer.play();
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _audioPlayer = AudioPlayer()..setAsset(_audioFile);
    _audioPlayer.setVolume(1);
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _effectPlayer.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    countDownModalBg = 'assets/images/modalIMG/bg.png';
    countDownModalBtn = 'assets/images/modalIMG/btn.png';

    return Container(
      // padding: const EdgeInsets.only(top: 588),
        child: AlertDialog(
          alignment: Alignment.topCenter,
          content: Stack(children: [
            Center(
              child: Container(
                width: 828,
                height: 531,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(countDownModalBg), fit: BoxFit.fill)),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 25),
                        height: 320,
                        width: 828,
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Container(
                              margin: EdgeInsets.all(6),
                              width: 640,
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('비상정지 버튼이 눌려있습니다.',
                                      style: TextStyle(
                                          fontFamily: 'kor',
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.2)),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 672,
                          height: 102,
                          decoration: BoxDecoration(
                            // border: Border.fromBorderSide(
                            //     BorderSide(width: 5, color: Colors.tealAccent)),
                              image: DecorationImage(
                                  image: AssetImage(countDownModalBtn), fit: BoxFit.fill)),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                enableFeedback: false,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                fixedSize: const Size(370, 120)),
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _effectPlayer.seek(const Duration(seconds: 0));
                                _effectPlayer.play();
                                Navigator.pop(context);
                              });
                            },
                            child: const Center(
                              child: Text(
                                '확인',
                                style: TextStyle(
                                    color: Color.fromRGBO(238, 238, 238, 0.7),
                                    height: 1.2,
                                    fontFamily: 'kor',
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]),
          backgroundColor: Colors.transparent,
          contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        ));
  }
}
