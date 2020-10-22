import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  Country _transfer;
  Country _receiver;
  String _exchangeRate = '1,130.05 KRW/USD';
  String _requestDateTime = '2019-03-20 16:13';

  double _transferAmount = 100;

  String _recieveAmount = '113,004.98 KRW';

  TextEditingController _transferAmountTextEditingController;

  @override
  void initState() {
    _transfer = Country(name: '미국', symbol: 'USD');
    _receiver = Country(name: '한국', symbol: 'KRW');

    _transferAmountTextEditingController =
        TextEditingController(text: _transferAmount.toString());
    super.initState();
  }

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
                      Text(_transfer.nameWithSymbol),
                    ]),
                    TableRow(children: [
                      Text(
                        '수취국가 : ',
                        textAlign: TextAlign.right,
                      ),
                      Text(_receiver.nameWithSymbol),
                    ]),
                    TableRow(children: [
                      Text(
                        '환율 : ',
                        textAlign: TextAlign.right,
                      ),
                      Text(_exchangeRate),
                    ]),
                    TableRow(children: [
                      Text(
                        '조회 시간 : ',
                        textAlign: TextAlign.right,
                      ),
                      Text(_requestDateTime),
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
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller:
                                        _transferAmountTextEditingController,
                                    onFieldSubmitted: _onFieldSubmitted,
                                    validator: (value) {
                                      try {
                                        double.parse(value);
                                        return null;
                                      } catch (e) {
                                        return '올바른 송금액을 입력하세요.';
                                      }
                                    },
                                    onSaved: (String value) {
                                      setState(() => _transferAmount =
                                          double.parse(value));
                                    },
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false, signed: false),
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 0,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        borderSide: BorderSide(
                                            color: Colors.blueAccent,
                                            width: 1.0),
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
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(_transfer.symbol),
                            ))
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
                    '수취금액은 $_recieveAmount 입니다.',
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

  void _onFieldSubmitted(value) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    _convertCurrency(
      transfer: _transfer,
      receiver: _receiver,
      amount: _transferAmount,
    ).then((value) {
      setState(() {
        _requestDateTime = DateTime.now().toLocal().toIso8601String();
      });
    });
  }

  Future _convertCurrency({Country transfer, Country receiver, double amount}) {
    return Future.value(100);
  }
}

class Country {
  String name;
  String symbol;

  Country({@required this.name, @required this.symbol})
      : assert(name != null),
        assert(symbol != null);

  String get nameWithSymbol => '$name ($symbol)';
}
