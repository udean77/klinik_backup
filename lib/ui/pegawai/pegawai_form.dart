import 'package:flutter/material.dart';
import '../../model/pegawai.dart';
import '../../service/jsonbin_service.dart';

class PegawaiFormPage extends StatefulWidget {
  final JsonbinService jsonbin;
  final Pegawai? pegawai;
  const PegawaiFormPage({Key? key, required this.jsonbin, this.pegawai})
    : super(key: key);

  @override
  State<PegawaiFormPage> createState() => _PegawaiFormPageState();
}

class _PegawaiFormPageState extends State<PegawaiFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaCtrl;
  late TextEditingController _peranCtrl;
  late TextEditingController _teleponCtrl;

  @override
  void initState() {
    super.initState();
    final s = widget.pegawai;
    _namaCtrl = TextEditingController(text: s?.nama ?? '');
    _peranCtrl = TextEditingController(text: s?.peran ?? '');
    _teleponCtrl = TextEditingController(text: s?.telepon ?? '');
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _peranCtrl.dispose();
    _teleponCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final s = Pegawai(
      id: widget.pegawai?.id,
      nama: _namaCtrl.text.trim(),
      peran: _peranCtrl.text.trim(),
      telepon: _teleponCtrl.text.trim(),
    );
    try {
      if (widget.pegawai == null) {
        final created = await widget.jsonbin.createPegawai(s);
        Navigator.of(context).pop(created);
      } else {
        final updated = await widget.jsonbin.updatePegawai(
          widget.pegawai!.id!,
          s,
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
        title: Text(widget.pegawai == null ? 'Tambah Pegawai' : 'Edit Pegawai'),
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
                controller: _peranCtrl,
                decoration: const InputDecoration(labelText: 'Jabatan'),
              ),
              TextFormField(
                controller: _teleponCtrl,
                decoration: const InputDecoration(labelText: 'Telepon'),
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
