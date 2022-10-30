import 'package:flutter/material.dart';
import 'package:scan/scan.dart';



class ScanQR_Water extends StatefulWidget {
  const ScanQR_Water({Key? key}) : super(key: key);

  @override
  State<ScanQR_Water> createState() => _ScanQR_WaterState();
}

class _ScanQR_WaterState extends State<ScanQR_Water> {

  ScanController controller = ScanController();
  String qrcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ScanView(
          controller: controller,
          scanAreaScale: .7,
          scanLineColor: Colors.green.shade400,
          onCapture: (data){
            Navigator.pop(context,data.toString());
          },
        ),
      ),
    );
  }
}
