import 'package:flutter/material.dart';
import '../../model/pembayaran.dart';
import '../../model/reservasi.dart';
import '../../service/jsonbin_service.dart';

class PembayaranFormPage extends StatefulWidget {
  final JsonbinService jsonbin;
  final Pembayaran? pembayaran;
  const PembayaranFormPage({Key? key, required this.jsonbin, this.pembayaran})
    : super(key: key);

  @override
  State<PembayaranFormPage> createState() => _PembayaranFormPageState();
}

class _PembayaranFormPageState extends State<PembayaranFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jumlahCtrl;
  late TextEditingController _metodeCtrl;
  late TextEditingController _statusCtrl;
  List<Reservasi> _reservasi = [];
  String? _selectedReservasi;

  @override
  void initState() {
    super.initState();
    final p = widget.pembayaran;
    _jumlahCtrl = TextEditingController(
      text: p != null ? p.jumlah.toString() : '',
    );
    _metodeCtrl = TextEditingController(text: p?.metode ?? '');
    _statusCtrl = TextEditingController(text: p?.status ?? 'pending');
    _selectedReservasi = p?.reservasiId;
    _loadReservasi();
  }

  Future<void> _loadReservasi() async {
    try {
      final list = await widget.jsonbin.getReservasi();
      setState(() {
        _reservasi = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal load reservasi: $e')));
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedReservasi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih reservasi terlebih dahulu')),
      );
      return;
    }

    final p = Pembayaran(
      id: widget.pembayaran?.id,
      reservasiId: _selectedReservasi!,
      jumlah: double.tryParse(_jumlahCtrl.text.trim()) ?? 0.0,
      metode: _metodeCtrl.text.trim(),
      status: _statusCtrl.text.trim(),
      waktu: DateTime.now().toIso8601String(),
    );

    try {
      if (widget.pembayaran == null) {
        final created = await widget.jsonbin.createPembayaran(p);
        Navigator.of(context).pop(created);
      } else {
        final updated = await widget.jsonbin.updatePembayaran(
          widget.pembayaran!.id!,
          p,
        );
        Navigator.of(context).pop(updated);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pembayaran == null ? 'Tambah Pembayaran' : 'Edit Pembayaran',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedReservasi,
                hint: const Text('Pilih Reservasi'),
                items:
                    _reservasi
                        .map(
                          (r) => DropdownMenuItem(
                            value: r.id,
                            child: Text(r.id ?? ''),
                          ),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _selectedReservasi = v),
                validator: (v) => v == null ? 'Pilih reservasi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahCtrl,
                decoration: const InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Masukkan jumlah';
                  if (int.tryParse(v) == null)
                    return 'Format jumlah tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _metodeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Metode (cash/debit/transfer)',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (v) => (v == null || v.isEmpty) ? 'Masukkan metode' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _statusCtrl,
                decoration: const InputDecoration(
                  labelText: 'Status (pending/paid/failed)',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (v) => (v == null || v.isEmpty) ? 'Masukkan status' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _save, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _jumlahCtrl.dispose();
    _metodeCtrl.dispose();
    _statusCtrl.dispose();
    super.dispose();
  }
}
