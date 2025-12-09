import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/dokter.dart';
import '../model/pasien.dart';
import '../model/pegawai.dart';
import '../model/reservasi.dart';
import '../model/pembayaran.dart';

/// JSONBin service untuk menyimpan dan mengambil data dari JSONBin.io
/// Endpoint: https://api.jsonbin.io/v3/b/{binId}
/// Dengan master key: {masterKey}
class JsonbinService {
  final String binId;
  final String masterKey;

  JsonbinService({required this.binId, required this.masterKey});

  Uri get _endpoint => Uri.parse('https://api.jsonbin.io/v3/b/$binId');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-Master-Key': masterKey,
  };

  /// Fetch semua data dari JSONBin
  Future<Map<String, dynamic>> _fetchAll() async {
    final res = await http.get(_endpoint, headers: _headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['record'] ?? {};
    }
    throw Exception('Failed to fetch data: ${res.statusCode}');
  }

  /// Update seluruh bin dengan data baru
  Future<void> _updateBin(Map<String, dynamic> data) async {
    final res = await http.put(
      _endpoint,
      headers: _headers,
      body: jsonEncode(data),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update bin: ${res.statusCode}');
    }
  }

  // ===== Dokter =====
  Future<List<Dokter>> getDokter() async {
    final all = await _fetchAll();
    final List dokterList = all['dokter'] ?? [];
    return dokterList.map((e) => Dokter.fromJson(e)).toList();
  }

  Future<Dokter> createDokter(Dokter d) async {
    final all = await _fetchAll();
    final dokterList = List<Map<String, dynamic>>.from(
      (all['dokter'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final id =
        (dokterList.isEmpty
            ? 0
            : int.tryParse(dokterList.last['id']?.toString() ?? '0') ?? 0) +
        1;
    final newDokter = Dokter(
      id: id.toString(),
      nama: d.nama,
      spesialisasi: d.spesialisasi,
      fotoUrl: d.fotoUrl,
      telepon: d.telepon,
      email: d.email,
    );
    dokterList.add(newDokter.toJson());
    all['dokter'] = dokterList;
    await _updateBin(all);
    return newDokter;
  }

  Future<Dokter> updateDokter(String id, Dokter d) async {
    final all = await _fetchAll();
    final dokterList = List<Map<String, dynamic>>.from(
      (all['dokter'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final idx = dokterList.indexWhere((e) => e['id'].toString() == id);
    if (idx < 0) throw Exception('Dokter not found');
    dokterList[idx] = {...d.toJson(), 'id': id};
    all['dokter'] = dokterList;
    await _updateBin(all);
    return Dokter.fromJson(dokterList[idx]);
  }

  Future<void> deleteDokter(String id) async {
    final all = await _fetchAll();
    final dokterList = List<Map<String, dynamic>>.from(
      (all['dokter'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    dokterList.removeWhere((e) => e['id'].toString() == id);
    all['dokter'] = dokterList;
    await _updateBin(all);
  }

  // ===== Pasien =====
  Future<List<Pasien>> getPasien() async {
    final all = await _fetchAll();
    final List pasienList = all['pasien'] ?? [];
    return pasienList.map((e) => Pasien.fromJson(e)).toList();
  }

  Future<Pasien> createPasien(Pasien p) async {
    final all = await _fetchAll();
    final pasienList = List<Map<String, dynamic>>.from(
      (all['pasien'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final id =
        (pasienList.isEmpty
            ? 0
            : int.tryParse(pasienList.last['id']?.toString() ?? '0') ?? 0) +
        1;
    final newPasien = Pasien(
      id: id.toString(),
      nama: p.nama,
      tanggalLahir: p.tanggalLahir,
      telepon: p.telepon,
      alamat: p.alamat,
    );
    pasienList.add(newPasien.toJson());
    all['pasien'] = pasienList;
    await _updateBin(all);
    return newPasien;
  }

  Future<Pasien> updatePasien(String id, Pasien p) async {
    final all = await _fetchAll();
    final pasienList = List<Map<String, dynamic>>.from(
      (all['pasien'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final idx = pasienList.indexWhere((e) => e['id'].toString() == id);
    if (idx < 0) throw Exception('Pasien not found');
    pasienList[idx] = {...p.toJson(), 'id': id};
    all['pasien'] = pasienList;
    await _updateBin(all);
    return Pasien.fromJson(pasienList[idx]);
  }

  Future<void> deletePasien(String id) async {
    final all = await _fetchAll();
    final pasienList = List<Map<String, dynamic>>.from(
      (all['pasien'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    pasienList.removeWhere((e) => e['id'].toString() == id);
    all['pasien'] = pasienList;
    await _updateBin(all);
  }

  // ===== Pegawai =====
  Future<List<Pegawai>> getPegawai() async {
    final all = await _fetchAll();
    final List pegawaiList = all['pegawai'] ?? [];
    return pegawaiList.map((e) => Pegawai.fromJson(e)).toList();
  }

  Future<Pegawai> createPegawai(Pegawai s) async {
    final all = await _fetchAll();
    final pegawaiList = List<Map<String, dynamic>>.from(
      (all['pegawai'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final id =
        (pegawaiList.isEmpty
            ? 0
            : int.tryParse(pegawaiList.last['id']?.toString() ?? '0') ?? 0) +
        1;
    final newPegawai = Pegawai(
      id: id.toString(),
      nama: s.nama,
      peran: s.peran,
      telepon: s.telepon,
    );
    pegawaiList.add(newPegawai.toJson());
    all['pegawai'] = pegawaiList;
    await _updateBin(all);
    return newPegawai;
  }

  Future<Pegawai> updatePegawai(String id, Pegawai s) async {
    final all = await _fetchAll();
    final pegawaiList = List<Map<String, dynamic>>.from(
      (all['pegawai'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final idx = pegawaiList.indexWhere((e) => e['id'].toString() == id);
    if (idx < 0) throw Exception('Pegawai not found');
    pegawaiList[idx] = {...s.toJson(), 'id': id};
    all['pegawai'] = pegawaiList;
    await _updateBin(all);
    return Pegawai.fromJson(pegawaiList[idx]);
  }

  Future<void> deletePegawai(String id) async {
    final all = await _fetchAll();
    final pegawaiList = List<Map<String, dynamic>>.from(
      (all['pegawai'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    pegawaiList.removeWhere((e) => e['id'].toString() == id);
    all['pegawai'] = pegawaiList;
    await _updateBin(all);
  }

  // ===== Reservasi =====
  Future<List<Reservasi>> getReservasi() async {
    final all = await _fetchAll();
    final List reservasiList = all['reservasi'] ?? [];
    return reservasiList.map((e) => Reservasi.fromJson(e)).toList();
  }

  Future<Reservasi> createReservasi(Reservasi r) async {
    final all = await _fetchAll();
    final reservasiList = List<Map<String, dynamic>>.from(
      (all['reservasi'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final id =
        (reservasiList.isEmpty
            ? 0
            : int.tryParse(reservasiList.last['id']?.toString() ?? '0') ?? 0) +
        1;
    final newReservasi = Reservasi(
      id: id.toString(),
      dokterIdId: r.dokterIdId,
      pasienId: r.pasienId,
      tanggalWaktu: r.tanggalWaktu,
      status: r.status,
    );
    reservasiList.add(newReservasi.toJson());
    all['reservasi'] = reservasiList;
    await _updateBin(all);
    return newReservasi;
  }

  Future<Reservasi> getReservasiById(String id) async {
    final all = await _fetchAll();
    final List reservasiList = all['reservasi'] ?? [];
    final item = reservasiList.firstWhere(
      (e) => e['id'].toString() == id,
      orElse: () => null,
    );
    if (item == null) throw Exception('Reservasi not found');
    return Reservasi.fromJson(item);
  }

  Future<Reservasi> updateReservasi(String id, Reservasi r) async {
    final all = await _fetchAll();
    final reservasiList = List<Map<String, dynamic>>.from(
      (all['reservasi'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final idx = reservasiList.indexWhere((e) => e['id'].toString() == id);
    if (idx < 0) throw Exception('Reservasi not found');
    reservasiList[idx] = {...r.toJson(), 'id': id};
    all['reservasi'] = reservasiList;
    await _updateBin(all);
    return Reservasi.fromJson(reservasiList[idx]);
  }

  Future<void> deleteReservasi(String id) async {
    final all = await _fetchAll();
    final reservasiList = List<Map<String, dynamic>>.from(
      (all['reservasi'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    reservasiList.removeWhere((e) => e['id'].toString() == id);
    all['reservasi'] = reservasiList;
    await _updateBin(all);
  }

  // ===== Pembayaran =====
  Future<List<Pembayaran>> getPembayaran() async {
    final all = await _fetchAll();
    final List pembayaranList = all['pembayaran'] ?? [];
    return pembayaranList.map((e) => Pembayaran.fromJson(e)).toList();
  }

  Future<Pembayaran> createPembayaran(Pembayaran p) async {
    final all = await _fetchAll();
    final pembayaranList = List<Map<String, dynamic>>.from(
      (all['pembayaran'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final id =
        (pembayaranList.isEmpty
            ? 0
            : int.tryParse(pembayaranList.last['id']?.toString() ?? '0') ?? 0) +
        1;
    final newPembayaran = Pembayaran(
      id: id.toString(),
      reservasiId: p.reservasiId,
      jumlah: p.jumlah,
      metode: p.metode,
      status: p.status,
      waktu: p.waktu,
    );
    pembayaranList.add(newPembayaran.toJson());
    all['pembayaran'] = pembayaranList;
    await _updateBin(all);
    return newPembayaran;
  }

  Future<Pembayaran> getPembayaranById(String id) async {
    final all = await _fetchAll();
    final List pembayaranList = all['pembayaran'] ?? [];
    final item = pembayaranList.firstWhere(
      (e) => e['id'].toString() == id,
      orElse: () => null,
    );
    if (item == null) throw Exception('Pembayaran not found');
    return Pembayaran.fromJson(item);
  }

  Future<Pembayaran> updatePembayaran(String id, Pembayaran p) async {
    final all = await _fetchAll();
    final pembayaranList = List<Map<String, dynamic>>.from(
      (all['pembayaran'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    final idx = pembayaranList.indexWhere((e) => e['id'].toString() == id);
    if (idx < 0) throw Exception('Pembayaran not found');
    pembayaranList[idx] = {...p.toJson(), 'id': id};
    all['pembayaran'] = pembayaranList;
    await _updateBin(all);
    return Pembayaran.fromJson(pembayaranList[idx]);
  }

  Future<void> deletePembayaran(String id) async {
    final all = await _fetchAll();
    final pembayaranList = List<Map<String, dynamic>>.from(
      (all['pembayaran'] ?? []).map((e) => Map<String, dynamic>.from(e as Map)),
    );
    pembayaranList.removeWhere((e) => e['id'].toString() == id);
    all['pembayaran'] = pembayaranList;
    await _updateBin(all);
  }

  // ===== Login =====
  Future<bool> login(String username, String password) async {
    final all = await _fetchAll();
    final List users = all['users'] ?? [];
    final user = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => null,
    );
    return user != null;
  }

  /// Untuk role-based access: get user info by username
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final all = await _fetchAll();
    final List users = all['users'] ?? [];
    try {
      return users.firstWhere((u) => u['username'] == username);
    } catch (_) {
      return null;
    }
  }
}
