import 'package:flutter/material.dart';
import 'package:flutter_hms_scan_kit/flutter_hms_scan_kit.dart';
import 'package:flutter_hms_scan_kit/scan_result.dart';
import 'package:nnlg/utils/ToastUtil.dart';


class ScanKit_Water extends StatefulWidget {
  const ScanKit_Water({Key? key}) : super(key: key);

  @override
  State<ScanKit_Water> createState() => _ScanKit_WaterState();
}

class _ScanKit_WaterState extends State<ScanKit_Water> {
  ScanResult? _scanResult;

  Future scan() async{
    _scanResult = await FlutterHmsScanKit.scan;
    return _scanResult!.value;
  }
  @override
  Widget build(BuildContext context) {
    ScanType? scanType;
    ScanTypeFormat? scanTypeFormat;
    String? value;
    Navigator.pop(context,scan());
    return const Placeholder();
  }


}
