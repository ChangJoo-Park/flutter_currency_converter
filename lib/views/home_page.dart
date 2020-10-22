import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              // 제목
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 16),
                alignment: Alignment.center,
                child: Text('환율 계산', style: TextStyle(fontSize: 32)),
              ),
              // 테이블
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(4),
                  },
                  children: [
                    TableRow(children: [
                      Text(
                        '송금 국가 : ',
                        textAlign: TextAlign.right,
                      ),
                      Text('미국(USD)'),
                    ]),
                    TableRow(children: [
                      Text(
                        '수취국가 : ',
                        textAlign: TextAlign.right,
                      ),
                      Text('한국 (KRW)'),
                    ]),
                    TableRow(children: [
                      Text(
                        '환율 : ',
                        textAlign: TextAlign.right,
                      ),
                      Text('1,130.05 KRW/USD'),
                    ]),
                    TableRow(children: [
                      Text(
                        '조회 시간 : ',
                        textAlign: TextAlign.right,
                      ),
                      Text('2019-03-20 16:13'),
                    ]),
                    TableRow(
                      decoration: BoxDecoration(),
                      children: [
                        Text(
                          '송금액 : ',
                          textAlign: TextAlign.right,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 24,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Text(' USD'))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 결과
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '수취금액은 113,004.98 KRW 입니다.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
