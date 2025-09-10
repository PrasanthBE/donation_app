import 'dart:convert';
import 'package:http/http.dart' as http;

class Loginapi {
  Future<dynamic> loginRequest(String mobileNumber) async {
    print("Mobile Number: $mobileNumber"); //test
    //String serverUrl = global.coreserviceUrl;
    String serverUrl = "http://13.234.5.180:8180/origa-coreservice/rest/api";
    String apiName = "/Elogin/EngineerLogin/ssaEngineerLogin";
    String url = serverUrl + apiName;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(url));

    request.body = json.encode({"engineer_mobile": mobileNumber});

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();

    var data = json.decode(responseBody);
    return data;
  }

  Future<dynamic> verfiyOtp(
    String mobileNumber,
    int pin,
    String fcmtoken,
  ) async {
    // String serverUrl = global.coreserviceUrl;
    String serverUrl = "http://13.234.5.180:8180/origa-coreservice/rest/api";

    String apiName = "/Elogin/EngineerLogin/ssaEngineerLogin";
    String url = serverUrl + apiName;
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "engineer_mobile": mobileNumber,
      "otp": pin,
      "fcm_token": fcmtoken,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();

    var data = json.decode(responseBody);

    return data;
  }
}
