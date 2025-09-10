import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:akshaya_pathara/Global/global.dart' as global;

class SaveOnlineDonation {
  Future<Map<String, dynamic>> SubmitOnlineDonation(
    Map<String, dynamic> data,
  ) async {
    String serverUrl = global.testserverUrl;
    String apiName = "/saveDonation/";
    String url = serverUrl + apiName;
    print("submitDonation");

    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'i18n-language=en',
    };

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print(url);
    print("submitDonation");
    print(json.decode(responseBody));
    return json.decode(responseBody);
  }

  Future<Map<String, dynamic>> convertCurrency(
    String base,
    String target,
    String amount,
  ) async {
    String serverUrl = global.testserverUrl;
    String apiName = "/convertCurrency/";
    String url = serverUrl + apiName;

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"base": base, "target": target, "amount": amount}),
    );
    print(url);
    print("convertCurrency");
    print(json.decode(response.body));
    return json.decode(response.body);
  }
}
