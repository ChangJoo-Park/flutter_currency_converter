import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Country
///
/// 송금, 수취 국가로 사용하는 Country 클래스
/// [code]은 [format]에 사용됩니다
/// [format]은 [NumberFormat]이며 [country.format.format(<double>)] 과 같은 방법으로 사용해야합니다.
class Country {
  String name;
  String code;
  NumberFormat format;

  Country({
    @required this.name,
    @required this.code,
    this.format,
  })  : assert(name != null),
        assert(code != null) {
    String unicodeCurrencySign = '\u00a4';
    format = this.format ??
        NumberFormat.currency(
          symbol: code,
          decimalDigits: 2,
          customPattern: '#,###.## $unicodeCurrencySign',
        );
  }

  String get nameWithSymbol => '$name ($code)';
}
