import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BatteryRivePage extends StatefulWidget {
  const BatteryRivePage({super.key});

  @override
  State<BatteryRivePage> createState() => _BatteryRivePageState();
}

class _BatteryRivePageState extends State<BatteryRivePage> {
  final Battery _battery = Battery();
  int batteryLevel = 0;
  BatteryState batteryState = BatteryState.unknown;

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<double>? progressInput;

  @override
  void initState() {
    super.initState();
    _loadRive();
    _initBattery();
  }

  Future<void> _loadRive() async {
    final file = await RiveFile.asset('assets/rive/glass-battery.riv');
    final artboard = file.mainArtboard;

    _controller = StateMachineController.fromArtboard(
      artboard,
      'battery progress', 
    );

    if (_controller != null) {
      artboard.addController(_controller!);

      progressInput =
          _controller!.findInput<double>('progress'); 
    }

    setState(() => _riveArtboard = artboard);
  }

  Future<void> _initBattery() async {
    batteryLevel = await _battery.batteryLevel;
    batteryState = await _battery.batteryState;

    
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      batteryLevel = await _battery.batteryLevel;
      _updateRive();
      setState(() {});
    });

    _battery.onBatteryStateChanged.listen((state) {
      batteryState = state;
      setState(() {});
    });

    _updateRive();
  }

  void _updateRive() {
    if (progressInput == null) return;

    
    progressInput!.value = batteryLevel / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _riveArtboard == null
            ? const CircularProgressIndicator()
            : Rive(artboard: _riveArtboard!),
      ),
    );
  }
}
