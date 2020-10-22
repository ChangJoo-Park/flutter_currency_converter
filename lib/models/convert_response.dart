/// ConvertResponse
///
/// API를 요청하여 받은 결과 JSON을 객체로 변환하는 역할을 합니다.
/// 응답 예
///
/// 요청 : http://apilayer.net/api/live?access_key=460fb34ab450ccdcb229963f03f5fbd2&currencies=EUR,GBP,CAD,PLN&source=USD&format=1
/// {
///   "success":true,
///   "terms":"https:\/\/currencylayer.com\/terms",
///   "privacy":"https:\/\/currencylayer.com\/privacy",
///   "timestamp":1603298405,
///   "source":"USD",
///   "quotes":{
///      "USDKRW":1132.140365,
///      "USDJPY":104.4795,
///      "USDPHP":48.47702
///   }
/// }
class ConvertResponse {
  bool success;
  String terms;
  String privacy;
  DateTime timestamp;
  String source;
  Map<String, double> quotes;

  ConvertResponse({
    this.success,
    this.terms,
    this.privacy,
    this.timestamp,
    this.source,
    this.quotes,
  });

  factory ConvertResponse.fromJSON(Map<String, dynamic> json) =>
      ConvertResponse(
        success: json['success'],
        terms: json['terms'],
        privacy: json['privacy'],
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000),
        source: json['source'],
        quotes: json['quotes'],
      );
}
