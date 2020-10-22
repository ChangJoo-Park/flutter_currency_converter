import 'dart:convert' as convert;

import 'package:currency_converter/models/convert_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  Future<ConvertResponse> live({String source, List<String> currencies}) async {
    assert(source != null && source.isNotEmpty);
    assert(currencies != null && currencies.isNotEmpty);

    http.Client client = http.Client();
    String accessKey = DotEnv().env['CURRENCY_LAYER_ACCESS_KEY'];
    String baseURL = DotEnv().env['CURRENCY_LAYER_BASE_URL'];
    String endpoint =
        '$baseURL/live?access_key=$accessKey&source=$source&currencies=${currencies.join(',')}&format=1';
    ConvertResponse convertResponse;
    http.Response response = await client.get(endpoint);
    convertResponse =
        ConvertResponse.fromJSON(convert.jsonDecode(response.body));
    client.close();
    return convertResponse;
  }
}
