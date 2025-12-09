import 'package:flutter/material.dart';
import '../../model/pasien.dart';
import '../../service/jsonbin_service.dart';

class PasienFormPage extends StatefulWidget {
  final JsonbinService jsonbin;
  final Pasien? pasien;
  const PasienFormPage({Key? key, required this.jsonbin, this.pasien})
    : super(key: key);

  @override
  State<PasienFormPage> createState() => _PasienFormPageState();
}

class _PasienFormPageState extends State<PasienFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaCtrl;
  late TextEditingController _tanggalLahirCtrl;
  late TextEditingController _teleponCtrl;
  late TextEditingController _alamatCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.pasien;
    _namaCtrl = TextEditingController(text: p?.nama ?? '');
    _tanggalLahirCtrl = TextEditingController(text: p?.tanggalLahir ?? '');
    _teleponCtrl = TextEditingController(text: p?.telepon ?? '');
    _alamatCtrl = TextEditingController(text: p?.alamat ?? '');
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _teleponCtrl.dispose();
    _alamatCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final p = Pasien(
      id: widget.pasien?.id,
      nama: _namaCtrl.text.trim(),
      tanggalLahir: _tanggalLahirCtrl.text.trim(),
      telepon: _teleponCtrl.text.trim(),
      alamat: _alamatCtrl.text.trim(),
    );
    try {
      if (widget.pasien == null) {
        final created = await widget.jsonbin.createPasien(p);
        Navigator.of(context).pop(created);
      } else {
        final updated = await widget.jsonbin.updatePasien(
          widget.pasien!.id!,
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
        title: Text(widget.pasien == null ? 'Tambah Pasien' : 'Edit Pasien'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator:
                    (v) => v == null || v.trim().isEmpty ? 'Nama wajib' : null,
              ),
              TextFormField(
                controller: _tanggalLahirCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                ),
              ),
              TextFormField(
                controller: _teleponCtrl,
                decoration: const InputDecoration(labelText: 'Telepon'),
              ),
              TextFormField(
                controller: _alamatCtrl,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
