import 'package:currency_converter/models/convert_response.dart';
import 'package:currency_converter/models/exchange.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert' as convert;

class CurrencyService {
  Future<ConvertResponse> live({@required Exchange exchange}) async {
    assert(exchange != null);

    http.Client client = http.Client();
    String accessKey = DotEnv().env['CURRENCY_LAYER_ACCESS_KEY'];
    String baseURL = DotEnv().env['CURRENCY_LAYER_BASE_URL'];
    String endpoint =
        '$baseURL/live?access_key=$accessKey&source=USD&currencies=KRW,JPY,PHP&format=1';
    ConvertResponse convertResponse;
    http.Response response = await client.get(endpoint);
    convertResponse =
        ConvertResponse.fromJSON(convert.jsonDecode(response.body));
    client.close();
    return convertResponse;
  }
}
