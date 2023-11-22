import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../model/form.dart';

class FormController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxVOIcl4Fmp63HLJj3FY1cKemL4Kb3_76PgeIkHDU7b7_2gYN3zciHB9jFkdo0ujgMTfQ/exec";

  static const status_success = "SUCCESS";

  void submitForm(
    FeedbackForm feedbackForm,
    void Function(String) callback,
  ) async {
    try {
      final response =
          await http.post(Uri.parse(URL), body: feedbackForm.toJson());

      if (response.statusCode == 302) {
        final url = response.headers['location'];
        final getUrlResponse = await http.get(Uri.parse(url!));
        callback(convert.jsonDecode(getUrlResponse.body)['status']);
      } else {
        callback(convert.jsonDecode(response.body)['status']);
      }
    } catch (e) {
      print('Error submitting form: $e');
      callback('Error occurred: $e');
    }
  }
}
