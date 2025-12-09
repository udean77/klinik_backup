import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/dokter.dart';
import '../model/pasien.dart';
import '../model/pegawai.dart';
import '../model/reservasi.dart';
import '../model/pembayaran.dart';

class ApiService {
  // Set this to your MockAPI base URL, e.g. 'https://63xxxxxx.mockapi.io/api/v1'
  final String baseUrl;

  ApiService({required this.baseUrl});

  Uri _endpoint(String path) => Uri.parse('$baseUrl/$path');

  // Dokter
  Future<List<Dokter>> getDokter() async {
    final res = await http.get(_endpoint('dokter'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data.map((e) => Dokter.fromJson(e)).toList();
    }
    throw Exception('Failed to load dokter: ${res.statusCode}');
  }

  Future<Dokter> createDokter(Dokter d) async {
    final res = await http.post(
      _endpoint('dokter'),
      body: jsonEncode(d.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200)
      return Dokter.fromJson(jsonDecode(res.body));
    throw Exception('Failed to create dokter: ${res.statusCode}');
  }

  Future<Dokter> updateDokter(String id, Dokter d) async {
    final res = await http.put(
      _endpoint('dokter/$id'),
      body: jsonEncode(d.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) return Dokter.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update dokter: ${res.statusCode}');
  }

  Future<void> deleteDokter(String id) async {
    final res = await http.delete(_endpoint('dokter/$id'));
    if (res.statusCode != 200 && res.statusCode != 204)
      throw Exception('Failed to delete dokter: ${res.statusCode}');
  }

  // Pasien
  Future<List<Pasien>> getPasien() async {
    final res = await http.get(_endpoint('pasien'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data.map((e) => Pasien.fromJson(e)).toList();
    }
    throw Exception('Failed to load pasien: ${res.statusCode}');
  }

  Future<Pasien> createPasien(Pasien p) async {
    final res = await http.post(
      _endpoint('pasien'),
      body: jsonEncode(p.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200)
      return Pasien.fromJson(jsonDecode(res.body));
    throw Exception('Failed to create pasien: ${res.statusCode}');
  }

  Future<Pasien> updatePasien(String id, Pasien p) async {
    final res = await http.put(
      _endpoint('pasien/$id'),
      body: jsonEncode(p.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) return Pasien.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update pasien: ${res.statusCode}');
  }

  Future<void> deletePasien(String id) async {
    final res = await http.delete(_endpoint('pasien/$id'));
    if (res.statusCode != 200 && res.statusCode != 204)
      throw Exception('Failed to delete pasien: ${res.statusCode}');
  }

  // Pegawai
  Future<List<Pegawai>> getPegawai() async {
    final res = await http.get(_endpoint('pegawai'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data.map((e) => Pegawai.fromJson(e)).toList();
    }
    throw Exception('Failed to load pegawai: ${res.statusCode}');
  }

  Future<Pegawai> createPegawai(Pegawai s) async {
    final res = await http.post(
      _endpoint('pegawai'),
      body: jsonEncode(s.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200)
      return Pegawai.fromJson(jsonDecode(res.body));
    throw Exception('Failed to create pegawai: ${res.statusCode}');
  }

  Future<Pegawai> updatePegawai(String id, Pegawai s) async {
    final res = await http.put(
      _endpoint('pegawai/$id'),
      body: jsonEncode(s.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) return Pegawai.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update pegawai: ${res.statusCode}');
  }

  Future<void> deletePegawai(String id) async {
    final res = await http.delete(_endpoint('pegawai/$id'));
    if (res.statusCode != 200 && res.statusCode != 204)
      throw Exception('Failed to delete pegawai: ${res.statusCode}');
  }

  // Reservasi
  Future<List<Reservasi>> getReservasi() async {
    final res = await http.get(_endpoint('reservasi'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data.map((e) => Reservasi.fromJson(e)).toList();
    }
    throw Exception('Failed to load reservasi: ${res.statusCode}');
  }

  Future<Reservasi> createReservasi(Reservasi r) async {
    final res = await http.post(
      _endpoint('reservasi'),
      body: jsonEncode(r.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200)
      return Reservasi.fromJson(jsonDecode(res.body));
    throw Exception('Failed to create reservasi: ${res.statusCode}');
  }

  Future<Reservasi> getReservasiById(String id) async {
    final res = await http.get(_endpoint('reservasi/$id'));
    if (res.statusCode == 200) return Reservasi.fromJson(jsonDecode(res.body));
    throw Exception('Failed to get reservasi: ${res.statusCode}');
  }

  Future<Reservasi> updateReservasi(String id, Reservasi r) async {
    final res = await http.put(
      _endpoint('reservasi/$id'),
      body: jsonEncode(r.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) return Reservasi.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update reservasi: ${res.statusCode}');
  }

  Future<void> deleteReservasi(String id) async {
    final res = await http.delete(_endpoint('reservasi/$id'));
    if (res.statusCode != 200 && res.statusCode != 204)
      throw Exception('Failed to delete reservasi: ${res.statusCode}');
  }

  // Pembayaran
  Future<List<Pembayaran>> getPembayaran() async {
    final res = await http.get(_endpoint('pembayaran'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data.map((e) => Pembayaran.fromJson(e)).toList();
    }
    throw Exception('Failed to load pembayaran: ${res.statusCode}');
  }

  Future<Pembayaran> createPembayaran(Pembayaran p) async {
    final res = await http.post(
      _endpoint('pembayaran'),
      body: jsonEncode(p.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 201 || res.statusCode == 200)
      return Pembayaran.fromJson(jsonDecode(res.body));
    throw Exception('Failed to create pembayaran: ${res.statusCode}');
  }

  Future<Pembayaran> getPembayaranById(String id) async {
    final res = await http.get(_endpoint('pembayaran/$id'));
    if (res.statusCode == 200) return Pembayaran.fromJson(jsonDecode(res.body));
    throw Exception('Failed to get pembayaran: ${res.statusCode}');
  }

  Future<Pembayaran> updatePembayaran(String id, Pembayaran p) async {
    final res = await http.put(
      _endpoint('pembayaran/$id'),
      body: jsonEncode(p.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) return Pembayaran.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update pembayaran: ${res.statusCode}');
  }

  Future<void> deletePembayaran(String id) async {
    final res = await http.delete(_endpoint('pembayaran/$id'));
    if (res.statusCode != 200 && res.statusCode != 204)
      throw Exception('Failed to delete pembayaran: ${res.statusCode}');
  }
}
