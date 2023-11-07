import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kori_wis_demo/Modals/FacilityModalFinal.dart';
import 'package:kori_wis_demo/Providers/MainStatusModel.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityListScreenNew.dart';
import 'package:kori_wis_demo/Screens/Services/Facility/FacilityScreen.dart';
import 'package:kori_wis_demo/Utills/navScreens.dart';
import 'package:kori_wis_demo/Widgets/appBarStatus.dart';
import 'package:provider/provider.dart';

class FacilityListSearchScreenNew extends StatefulWidget {
  const FacilityListSearchScreenNew({Key? key}) : super(key: key);

  @override
  State<FacilityListSearchScreenNew> createState() =>
      _FacilityListSearchScreenNewState();
}

class _FacilityListSearchScreenNewState
    extends State<FacilityListSearchScreenNew> {
  late int officeQTY;
  late List<String> officeNum;
  late List<String> officeName;
  late List<String> officeDetail;

  late MainStatusModel _mainStatusProvider;

  final String backBTN = 'assets/images/facility/listView/btn.svg';
  final String findingBTN = 'assets/images/facility/listView/findBTN.svg';
  final String searchBTN = 'assets/images/facility/listView/btn_2.svg';
  final String informName = 'assets/images/facility/listView/7_f.svg';
  final String informBottomBanner =
      'assets/images/facility/listView/bottom.png';

  late String searchResult;

  late Color searchBorderLine;
  late double findBTNOpacity;

  late AudioPlayer _effectPlayer;
  final String _effectFile = 'assets/sounds/button_click.wav';

  final TextEditingController searchingController = TextEditingController();

  late bool searchDone;
  late bool searchFail;
  late int searchIndex;

  // String searchText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudio();
    searchResult = '';
    officeName = [
      '(주)딜라이브',
      '아워팜',
      '브레인컴퍼니',
      'DAWON\nTax Office',
      '(주)드림디엔에스',
      '(주)범건축종합\n건축사사무소',
      'Daily Vegan',
      '(주)엘렉시',
      '신영비엠이(주)',
      'HD인베스트',
      '(주)엑사로보틱스',
      '수성엔지니어링',
      '(주)딜라이브\n자재실',
      'JS융합인재교육원(주)',
      '엘리베이터',
      '화장실1',
      '화장실2'
    ];
    for (int i = 0;
        i <
            Provider.of<MainStatusModel>(context, listen: false)
                .facilityNum!
                .length;
        i++) {
      setState(() {
        officeNum =
            Provider.of<MainStatusModel>(context, listen: false).facilityNum!;
        officeDetail = Provider.of<MainStatusModel>(context, listen: false)
            .facilityDetail!;
      });
    }
    officeQTY = officeNum.length;
    searchBorderLine = Color(0xffd9d9d9);
    findBTNOpacity = 0.3;
    searchDone = false;
    searchFail = false;
    searchIndex = 0;
    // }
  }

  void _initAudio() {
    // AudioPlayer.clearAssetCache();
    _effectPlayer = AudioPlayer()..setAsset(_effectFile);
    _effectPlayer.setVolume(0.4);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _effectPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainStatusProvider = Provider.of<MainStatusModel>(context, listen: false);

    print(officeNum);
    print(officeName);
    print(officeDetail);

    return Scaffold(
      backgroundColor: Color(0xff191919).withOpacity(0.1),
      body: Container(
        width: 1080,
        height: 1920,
        child: Stack(
          children: [
            Positioned(
              top: 10 * 3,
              left: 17 * 3,
              child: Stack(children: [
                SvgPicture.asset(
                  backBTN,
                  width: 29 * 3,
                  height: 24 * 3,
                  fit: BoxFit.cover,
                ),
                FilledButton(
                    style: FilledButton.styleFrom(
                        fixedSize: const Size(29 * 3, 24 * 3),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _effectPlayer.seek(const Duration(seconds: 0));
                        _effectPlayer.play();
                        Future.delayed(const Duration(milliseconds: 230), () {
                          _effectPlayer.dispose();
                          navPage(
                              context: context,
                              page: FacilityListScreenNew(
                                hideThings: false,
                              )).navPageToPage();
                        });
                      });
                    },
                    child: null),
              ]),
            ),
            Positioned(
              top: 52 * 3,
              left: 24 * 3,
              child: SizedBox(
                width: 312 * 3,
                height: 26 * 3,
                child: TextField(
                  controller: searchingController,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: '원하시는 장소를 입력하세요',
                    hintStyle: TextStyle(
                        fontFamily: 'kor',
                        fontSize: 15 * 3,
                        color: Color(0xffffffff).withOpacity(0.6),
                        fontWeight: FontWeight.w400),
                    hintTextDirection: TextDirection.ltr,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1 * 3,
                            color: searchBorderLine,
                            style: BorderStyle.solid)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 1 * 3,
                            color: Color(0xffd9d9d9),
                            style: BorderStyle.solid)),
                    prefixIcon: SizedBox(
                      width: 20 * 3,
                      child: Center(
                        child: Icon(
                          Icons.search,
                          color: Color(0xffaeaeae),
                          size: 16 * 3,
                        ),
                      ),
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.bottom,
                  style: const TextStyle(
                    fontFamily: 'kor',
                    fontSize: 35,
                    color: Color(0xffffffff),
                  ),
                  cursorColor: Colors.black,
                  onTap: () {
                    setState(() {
                      searchingController.text = '';
                      searchBorderLine = Color(0xffd9d9d9);
                      searchDone = false;
                      searchFail = false;
                      findBTNOpacity = 1;
                    });
                  },
                  onSubmitted: (value) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: []);
                    setState(() {
                      searchResult = searchingController.text;
                      for(int i = 0; i<officeName.length; i++){
                        if(searchDone == false){
                          if(!officeName[i].toLowerCase().contains(searchResult.toLowerCase())){
                            print('-----------------------------------');
                            print(officeName[i]);
                            print(searchResult);
                            print('-----------------------------------');
                            searchFail = true;
                            searchBorderLine = Color(0xffff453a);
                          }else{
                            searchFail = false;
                            searchDone = true;
                            searchIndex = i;
                            searchBorderLine = Color(0xff00d7d4);
                          }
                        }
                      }
                    });
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: []);
                  },
                ),
              ),
            ),
            Positioned(
              top: 48 * 3,
              left: 294 * 3,
              child: Container(
                width: 42 * 3,
                height: 24 * 3,
                color: Colors.transparent,
                child: Opacity(
                  opacity: findBTNOpacity,
                  child: Stack(children: [
                    FilledButton(
                        onPressed: () {
                          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                              overlays: []);
                          setState(() {
                            searchResult = searchingController.text;
                            for(int i = 0; i<officeName.length; i++){
                              if(searchDone == false){
                                if(!officeName[i].toLowerCase().contains(searchResult.toLowerCase())){
                                  print('-----------------------------------');
                                  print(officeName[i]);
                                  print(searchResult);
                                  print('-----------------------------------');
                                  searchBorderLine = Color(0xffff453a);
                                }else{
                                  searchDone = true;
                                  searchBorderLine = Color(0xff00d7d4);
                                }
                              }
                            }
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          fixedSize: Size(42*3, 24*3),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.5*3, color: Colors.white),
                            borderRadius: BorderRadius.circular(4*3)
                          )
                        ),
                        child: Text(
                          '찾기',
                          style: TextStyle(fontFamily: 'kor', fontSize: 10*3, letterSpacing: -0.30, height: 0.95),
                        )),
                  ]),
                ),
              ),
            ),
            Positioned(
              top: 86 * 3,
              left: 26 * 3,
              child: Offstage(
                offstage: !searchFail,
                child: Container(
                  width: 105*3,
                  height: 13*3,
                  child: Text(
                    '입력하신 장소가 없습니다.',
                    style: TextStyle(
                      fontFamily: 'kor',
                      fontSize: 10*3,
                      color: Color(0xffff453a),
                      letterSpacing: -2
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 179 * 3,
              left: 127 * 3,
              child: Offstage(
                offstage: !searchDone,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      fixedSize: Size(106 * 3, 86 * 3),
                      backgroundColor: Color(0xff333333).withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4 * 3),
                        side: BorderSide(width: 1, color: Colors.tealAccent),
                      )),
                  onPressed: () {
                    _effectPlayer.seek(const Duration(seconds: 0));
                    _effectPlayer.play();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      setState(() {
                        _mainStatusProvider.targetFacilityIndex = searchIndex;
                        _mainStatusProvider.facilitySelectByBTN = true;
                      });
                      navPage(context: context, page: FacilityScreen()).navPageToPage();
                      // facilityInform(context, 15);
                    });
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 17 * 3),
                      Container(
                        width: 34 * 3,
                        height: 16 * 3,
                        decoration: BoxDecoration(
                            color: Color(0xff000000).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8 * 3)),
                        child: Text(
                          officeNum[searchIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'kor',
                              fontSize: 11 * 3,
                              color: Color(0xff00d7d4),
                              height: 1.4),
                        ),
                      ),
                      SizedBox(
                        height: 12.5 * 3,
                      ),
                      Container(
                        width: 106 * 3,
                        height: 27.5 * 3,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(width: 1, color: Colors.red))),
                        child: Center(
                          child: Text(
                            officeName[searchIndex],
                            style: TextStyle(
                                fontFamily: 'kor',
                                fontSize: 12 * 3,
                                letterSpacing: -0.21,
                                color: Color(0xffffffff),
                                height: 1.1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
