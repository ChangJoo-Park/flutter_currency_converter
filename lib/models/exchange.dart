import 'package:flutter/material.dart';

import 'country.dart';

/// Exchange
///
/// 환전 정보를 담는 객체입니다.
/// 송금 국가인 [transfer]와 수취 국가인 [receiver] 그리고 환율 [rate]를 이용하여
/// 송금액 [amount]를 변환할 수 있습니다. 결과는 [receiveAmount]를 사용하세요.
class Exchange {
  Country transfer;
  Country receiver;
  double amount;
  double rate;
  DateTime timestamp;

  Exchange({
    @required this.transfer,
    @required this.receiver,
    @required this.amount,
  })  : assert(transfer != null),
        assert(receiver != null),
        assert(amount != null && amount > 0);

  symbolWithDelimiter({delimiter = ''}) {
    return '${transfer.symbol}$delimiter${receiver.symbol}';
  }

  @override
  String toString() {
    return '$rate ${symbolWithDelimiter(delimiter: "/")}';
  }

  double get receiveAmount => amount * rate;
}