import 'package:currency_converter/models/convert_response.dart';
import 'package:currency_converter/models/country.dart';
import 'package:currency_converter/models/exchange.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  Country _transfer;
  Country _receiver;
  List<Country> _supportedCountryList = [
    Country(name: '한국', symbol: 'KRW'),
    Country(name: '일본', symbol: 'JPY'),
    Country(name: '필리핀', symbol: 'PHP'),
  ];

  Exchange _exchange;
  String _requestDateTime = '';
  double _transferAmount = 100;
  String _receiveAmount = '';

  TextEditingController _transferAmountTextEditingController;

  @override
  void initState() {
    _transfer = Country(name: '미국', symbol: 'USD');
    _receiver = Country(name: '한국', symbol: 'KRW');
    _transferAmountTextEditingController =
        TextEditingController(text: _transferAmount.toString());
    _convertCurrency();
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
                        '수취 국가 : ',
                        textAlign: TextAlign.right,
                      ),
                      GestureDetector(
                        child: Text(_receiver.nameWithSymbol),
                        onTap: () {
                          showDialog(
                            context: context,
                            child: SimpleDialog(
                              title: Text('대상 국가를 선택하세요'),
                              children: _supportedCountryList
                                  .map((country) => SimpleDialogOption(
                                        child: Text(country.nameWithSymbol),
                                        onPressed: () {
                                          setState(() => _receiver = country);
                                          Navigator.of(context).pop();
                                          _convertCurrency();
                                        },
                                      ))
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ]),
                    TableRow(children: [
                      Text(
                        '환율 : ',
                        textAlign: TextAlign.right,
                      ),
                      Text('${_exchange ?? ""}'),
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
                    '수취금액은 $_receiveAmount 입니다.',
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

  // 모바일 키보드의 Submit 버튼을 눌렀을 때 발생
  void _onFieldSubmitted(value) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    _convertCurrency();
  }

  // 수취 국가가 변경되거나, 송금액이 변경되면 호출하여 환전 결과를 반영합니다.
  void _convertCurrency() {
    _requestAPI(Exchange(
      transfer: _transfer,
      receiver: _receiver,
      amount: _transferAmount,
    )).then((Exchange exchange) {
      setState(() {
        _exchange = exchange;
        _requestDateTime = _formatDateTime(exchange.timestamp.toLocal());
        _receiveAmount = _receiver.format.format(_exchange.receiveAmount);
      });
    });
  }

  // TODO: Service 로 변경해야함
  Future<Exchange> _requestAPI(Exchange exchange) {
    ConvertResponse convertResponse = ConvertResponse.fromJSON({
      "success": true,
      "terms": "https:\/\/currencylayer.com\/terms",
      "privacy": "https:\/\/currencylayer.com\/privacy",
      "timestamp": 1603298405,
      "source": "USD",
      "quotes": {"USDKRW": 1132.140365, "USDJPY": 104.4795, "USDPHP": 48.47702}
    });

    Exchange result = exchange;
    result.rate =
        convertResponse.quotes[result.symbolWithDelimiter(delimiter: '')];
    result.timestamp = convertResponse.timestamp;
    return Future.value(result);
  }

  /// 날짜 포맷
  ///
  /// 포맷규격 : 'yyyy-MM-dd HH:mm'
  /// 예 : 2019-03-20 16:13
  ///
  String _formatDateTime(DateTime dateTime, {bool local = true}) {
    assert(dateTime != null);
    DateTime target = dateTime;
    if (local) {
      target = target.toLocal();
    }
    return DateFormat('yyyy-MM-dd HH:mm').format(target);
  }
}
