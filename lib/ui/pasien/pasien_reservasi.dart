import 'package:flutter/material.dart';
import '../../model/dokter.dart';
import '../../model/reservasi.dart';
import '../../helpers/user_info.dart';
import '../../service/jsonbin_service.dart';

class PasienReservasiPage extends StatefulWidget {
  final JsonbinService jsonbin;
  const PasienReservasiPage({Key? key, required this.jsonbin})
    : super(key: key);

  @override
  State<PasienReservasiPage> createState() => _PasienReservasiPageState();
}

class _PasienReservasiPageState extends State<PasienReservasiPage> {
  List<Dokter> _dokter = [];
  List<Reservasi> _reservasi = [];
  String? _selectedDokter;
  DateTime? _selectedDateTime;
  bool _loading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final userId = await UserInfo().getUserID();
      final dok = await widget.jsonbin.getDokter();
      final res = await widget.jsonbin.getReservasi();
      setState(() {
        _currentUserId = userId;
        _dokter = dok;
        _reservasi = res;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _createReservasi() async {
    if (_selectedDokter == null || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih dokter dan tanggal waktu')),
      );
      return;
    }

    if (_currentUserId == null || _currentUserId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User ID tidak ditemukan')));
      return;
    }

    try {
      final r = Reservasi(
        dokterIdId: _selectedDokter!,
        pasienId: _currentUserId!,
        tanggalWaktu: _selectedDateTime!.toIso8601String(),
        status: 'pending',
      );
      await widget.jsonbin.createReservasi(r);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservasi berhasil dibuat')),
      );
      _selectedDokter = null;
      _selectedDateTime = null;
      _load();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuat reservasi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Reservasi')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Dokter:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDokter,
                      hint: const Text('Pilih dokter'),
                      items:
                          _dokter
                              .map(
                                (d) => DropdownMenuItem(
                                  value: d.id,
                                  child: Text(
                                    '${d.nama} (${d.spesialisasi ?? "-"})',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _selectedDokter = v),
                      validator: (v) => v == null ? 'Pilih dokter' : null,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tanggal & Waktu:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDateTime,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedDateTime != null
                              ? _selectedDateTime!.toString().substring(0, 16)
                              : 'Pilih tanggal & waktu',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _createReservasi,
                        child: const Text('Buat Reservasi'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Reservasi Anda:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildReservasiList(),
                  ],
                ),
              ),
    );
  }

  Widget _buildReservasiList() {
    final userRes =
        _reservasi.where((r) {
          return r.pasienId == _currentUserId;
        }).toList();

    if (userRes.isEmpty) {
      return const Center(child: Text('Belum ada reservasi'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: userRes.length,
      itemBuilder: (context, i) {
        final r = userRes[i];
        final dok = _dokter.firstWhere(
          (d) => d.id == r.dokterIdId,
          orElse: () => Dokter(id: '?', nama: '?', spesialisasi: '?'),
        );
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('Dr. ${dok.nama}'),
            subtitle: Text('${r.tanggalWaktu} - Status: ${r.status}'),
          ),
        );
      },
    );
  }
}
