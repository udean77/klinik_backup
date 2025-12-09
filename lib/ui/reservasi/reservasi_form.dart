import 'package:flutter/material.dart';
import '../../service/jsonbin_service.dart';
import '../../model/reservasi.dart';
import '../../model/dokter.dart';
import '../../model/pasien.dart';

class ReservasiFormPage extends StatefulWidget {
  final JsonbinService jsonbin;
  final Reservasi? reservasi;
  const ReservasiFormPage({Key? key, required this.jsonbin, this.reservasi})
    : super(key: key);

  @override
  _ReservasiFormPageState createState() => _ReservasiFormPageState();
}

class _ReservasiFormPageState extends State<ReservasiFormPage> {
  List<Dokter> _doctors = [];
  List<Pasien> _patients = [];
  String? _selectedDoctor;
  String? _selectedPatient;
  DateTime? _selectedDateTime;
  String _status = 'pending';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadRefs();
    if (widget.reservasi != null) {
      final r = widget.reservasi!;
      _selectedDoctor = r.dokterIdId;
      _selectedPatient = r.pasienId;
      try {
        _selectedDateTime = DateTime.parse(r.tanggalWaktu);
      } catch (_) {}
      _status = r.status ?? 'pending';
    }
  }

  Future<void> _loadRefs() async {
    final d = await widget.jsonbin.getDokter();
    final p = await widget.jsonbin.getPasien();
    setState(() {
      _doctors = d;
      _patients = p;
    });
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
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

  Future<void> _save() async {
    if (_selectedDoctor == null ||
        _selectedPatient == null ||
        _selectedDateTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lengkapi semua field')));
      return;
    }
    setState(() => _saving = true);
    final iso = _selectedDateTime!.toIso8601String();
    try {
      if (widget.reservasi == null) {
        final r = Reservasi(
          dokterIdId: _selectedDoctor!,
          pasienId: _selectedPatient!,
          tanggalWaktu: iso,
          status: _status,
        );
        await widget.jsonbin.createReservasi(r);
      } else {
        final id = widget.reservasi!.id!;
        final r = Reservasi(
          id: id,
          dokterIdId: _selectedDoctor!,
          pasienId: _selectedPatient!,
          tanggalWaktu: iso,
          status: _status,
        );
        await widget.jsonbin.updateReservasi(id, r);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Simpan gagal: $e')));
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        _selectedDateTime == null
            ? 'Pilih tanggal & waktu'
            : _selectedDateTime!.toLocal().toString().substring(0, 16);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reservasi == null ? 'Tambah Reservasi' : 'Edit Reservasi',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedDoctor,
              decoration: const InputDecoration(labelText: 'Pilih Dokter'),
              items:
                  _doctors
                      .map(
                        (d) =>
                            DropdownMenuItem(value: d.id, child: Text(d.nama)),
                      )
                      .toList(),
              onChanged: (v) => setState(() => _selectedDoctor = v),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedPatient,
              decoration: const InputDecoration(labelText: 'Pilih Pasien'),
              items:
                  _patients
                      .map(
                        (p) =>
                            DropdownMenuItem(value: p.id, child: Text(p.nama)),
                      )
                      .toList(),
              onChanged: (v) => setState(() => _selectedPatient = v),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text(dateLabel),
              leading: const Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'pending'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child:
                  _saving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
