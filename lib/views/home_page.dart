import 'package:currency_converter/models/convert_response.dart';
import 'package:currency_converter/models/country.dart';
import 'package:currency_converter/models/exchange.dart';
import 'package:currency_converter/services/currency_service.dart';
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
    Country(name: '한국', code: 'KRW'),
    Country(name: '일본', code: 'JPY'),
    Country(name: '필리핀', code: 'PHP'),
  ];

  Exchange _exchange;
  String _requestDateTime = '';
  double _transferAmount = 100;
  String _receiveAmount = '';

  TextEditingController _transferAmountTextEditingController;
  bool _isLoading = true;

  @override
  void initState() {
    _transfer = Country(name: '미국', code: 'USD');
    _receiver = Country(name: '한국', code: 'KRW');
    _transferAmountTextEditingController =
        TextEditingController(text: _transferAmount.toString());
    _convertCurrency();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            if (_isLoading) LinearProgressIndicator(),
            Container(
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
                          const TableLabel(text: '송금 국가'),
                          Text(_transfer.nameWithSymbol),
                        ]),
                        TableRow(children: [
                          const TableLabel(text: '수취 국가'),
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
                                              setState(
                                                  () => _receiver = country);
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
                          const TableLabel(text: '환율'),
                          Text(
                              '${_exchange?.receiver?.format?.format(_exchange?.rate) ?? ""}'),
                        ]),
                        TableRow(children: [
                          const TableLabel(text: '조회시간'),
                          Text(_requestDateTime),
                        ]),
                        TableRow(
                          decoration: BoxDecoration(),
                          children: [
                            const TableLabel(text: '송금액'),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        controller:
                                            _transferAmountTextEditingController,
                                        onFieldSubmitted: _onFieldSubmitted,
                                        validator: (value) {
                                          try {
                                            double amount = double.parse(value);
                                            if (amount < 0 || amount > 10000) {
                                              throw Error();
                                            }
                                            return null;
                                          } catch (e) {
                                            return '송금액이 바르지 않습니다.';
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
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            borderSide: BorderSide(
                                                color: Colors.blueAccent,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
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
                                  child: Text(_transfer.code),
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
          ],
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
    setState(() => _isLoading = true);
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
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }

  Future<Exchange> _requestAPI(Exchange exchange) {
    return CurrencyService()
        .live(
      source: exchange.transfer.code,
      currencies: _supportedCountryList.map((c) => c.code).toList(),
    )
        .then((ConvertResponse response) {
      Exchange result = exchange;
      double rate = response.quotes[result.symbolWithDelimiter(delimiter: '')];
      assert(rate != null);
      result.rate = rate;
      result.timestamp = response.timestamp;
      return result;
    });
  }

  /// 날짜 포맷
  ///
  /// 포맷규격 : 'yyyy-MM-dd HH:mm'
  /// 예 : 2019-03-20 16:13
  ///
  String _formatDateTime(
    DateTime dateTime, {
    bool local = true,
    String format = 'yyyy-MM-dd HH:mm',
  }) {
    assert(dateTime != null);
    DateTime target = dateTime;
    if (local) {
      target = target.toLocal();
    }
    return DateFormat(format).format(target);
  }
}

class TableLabel extends StatelessWidget {
  const TableLabel({Key key, this.text = ''}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      '$text : ',
      textAlign: TextAlign.right,
    );
  }
}
