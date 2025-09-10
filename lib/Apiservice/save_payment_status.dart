import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:akshaya_pathara/Global/global.dart' as global;

class SavePaymentStausDonation {
  Future<Map<String, dynamic>> CheckPaymentStatusDonation(
    donation_ref_id,
  ) async {
    String serverUrl = global.testserverUrl;
    String apiName = "/checkPaymentStatus/";
    String url = serverUrl + apiName;

    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'i18n-language=en',
    };

    print("donation_ref_id: $donation_ref_id");

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({"donation_ref_id": donation_ref_id});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();

    print("Request URL: $url");
    print("responseBody: $responseBody");

    var parsedResponse = json.decode(responseBody);

    // Return only the parsed JSON response
    return parsedResponse;
  }

  Future<Map<String, dynamic>> SavePayInfoDonation(
    donation_id,
    merchant_transaction_id,
    payment_url,
    payment_status,
  ) async {
    String serverUrl = global.testserverUrl;
    String apiName = "/savePayment/";
    String url = serverUrl + apiName;

    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'i18n-language=en',
    };

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "donation_ref_id": donation_id,
      "merchant_transaction_id": merchant_transaction_id,
      "payment_url": payment_url,
      "payment_status": payment_status,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();

    print("responseBody: $responseBody");

    // Decode and return only the response (no status code)
    return json.decode(responseBody);
  }
}
