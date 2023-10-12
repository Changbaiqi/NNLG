import 'package:flutter/material.dart';

class XiaoBei_qingjia extends StatefulWidget {
  const XiaoBei_qingjia({Key? key}) : super(key: key);

  @override
  State<XiaoBei_qingjia> createState() => _XiaoBei_qingjiaState();
}

class _XiaoBei_qingjiaState extends State<XiaoBei_qingjia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: XiaoBei_qjxx(),
    );
  }
}

class XiaoBei_qjxx extends StatefulWidget {
  const XiaoBei_qjxx({Key? key}) : super(key: key);

  @override
  State<XiaoBei_qjxx> createState() => _XiaoBei_qjxxState();
}

class _XiaoBei_qjxxState extends State<XiaoBei_qjxx> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 35,
              ),
              Container(
                height: 45,
                child: Image.asset('assets/images/xiaobei_title.png',fit: BoxFit.fill,width: MediaQuery.of(context).size.width,),
              )
            ],
          ),
          Expanded(
              flex: 1,
              child: ListView(
                children: [
                  Stack(

                    children: [
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child:  Stack(
                          children: [
                            Image.asset('assets/images/background.png',fit: BoxFit.fill,width: MediaQuery.of(context).size.width,),

                          ],
                        ),
                      )
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}

