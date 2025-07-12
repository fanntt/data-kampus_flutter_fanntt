import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/kampus_model.dart';

class ApiService {
  final String baseUrl = 'http://192.168.100.224:8000/api/data-kampus'; // ganti dengan URL kamu


  Future<List<Kampus>> getAllKampus() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Kampus.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }


  Future<void> deleteKampus(int no) async {
    final url = Uri.parse('$baseUrl/$no');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data');
    }
  }


  Future<void> tambahKampus(Kampus kampus) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(kampus.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal menambahkan data');
    }
  }


  Future<void> updateKampus(Kampus kampus) async {
    final url = Uri.parse('$baseUrl/${kampus.no}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(kampus.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate data');
    }
  }
}
