import 'dart:convert';
import 'package:http/http.dart' as http;

import '../class/Medicine.dart';
import '../utils/URLRequest.dart';

class MedicineApi {
  /*
  static Future<List<Medicine>> searchMedicine(String drugstoreId, String query) async {
    final response = await http.post(Uri.parse(URLRequest.URL_medicine_list),
        body: jsonEncode({"drugstoreID": drugstoreId}),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    print("searchMedicine : " + response.body.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> meds = map["result"];

      List<Medicine> listMedicine = [];
      if (meds != []) {
        for (dynamic m in meds) {
          Medicine ms = Medicine.fromJson(m);
          if ((ms.medName!.toLowerCase().contains(query.toLowerCase()) ||
              ms.medId!.toLowerCase().contains(query.toLowerCase()) ||
              ms.medDetail!.toLowerCase().contains(query.toLowerCase()))) {
            listMedicine.add(ms);
          }
        }
      }

      return listMedicine;
    } else {
      throw Exception();
    }
  }
   */
}
