import 'package:flutter/material.dart';

class MainStatusModel with ChangeNotifier {
  int? batBal;
  int? chargeFlag;
  int? emgButton;

  int? autoCharge;

  bool? fromDocking;

  bool? mainSoundMute;

  bool? restartService;

  bool? debugMode;

  int? robotServiceMode; // 0: 서빙, 1: 택배, 딜리버리

  MainStatusModel({
    this.debugMode,
    this.batBal,
    this.chargeFlag,
    this.emgButton,
    this.restartService,
    this.mainSoundMute,
    this.autoCharge,
  });
// 서빙 이송 중 광고 재생
}
