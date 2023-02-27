import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class ScanQRCode_Water extends StatefulWidget {
  const ScanQRCode_Water({Key? key}) : super(key: key);

  @override
  State<ScanQRCode_Water> createState() => _ScanQRCode_WaterState();
}

class _ScanQRCode_WaterState extends State<ScanQRCode_Water> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');



  @override
  Widget build(BuildContext context) {

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    print("扫描大小=$scanArea");
    print("width=${MediaQuery.of(context).size.width}");

    return Scaffold(
        body: SafeArea(  // add safe area here
            child:QRView(
              key: qrKey,
              // You can choose between CameraFacing.front or CameraFacing.back. Defaults to CameraFacing.back
              // cameraFacing: CameraFacing.front,
              onQRViewCreated: _onQRViewCreated,
              // Choose formats you want to scan. Defaults to all formats.
              // formatsAllowed: [BarcodeFormat.qrcode],
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
            )));
  }

  void _onQRViewCreated(QRViewController controller) {
    print("controller====");
    this.controller = controller;
    String? qrData;
    controller.scannedDataStream.listen((scanData) {
      print("scanData====$scanData");
      if (scanData != null) {
        qrData = scanData.code;
        controller.dispose();
      }
    }, onDone: () {
      Navigator.of(context).pop(qrData);
    });
    refresh();
  }

  void refresh() {
    Future.delayed(Duration(milliseconds: 100), () async {
      print("刷新相机");
      await controller!.pauseCamera();
      await controller!.resumeCamera();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
