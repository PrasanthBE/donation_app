import 'dart:convert';
import 'package:http/http.dart' as http;

class CommonApi {
  Future<dynamic> fetchDistricts(selectstate) async {
    String url = "https://ompextension.origa.market/api/getdistrictlist";

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({"state": selectstate}),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/form-data",
      },
      encoding: Encoding.getByName("utf-8"),
    );
    var data = json.decode(response.body.toString());
    return data;
  }
}
