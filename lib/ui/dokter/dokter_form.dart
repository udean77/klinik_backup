import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/dokter.dart';
import '../../service/jsonbin_service.dart';

class DokterFormPage extends StatefulWidget {
  final JsonbinService jsonbin;
  final Dokter? dokter;
  const DokterFormPage({Key? key, required this.jsonbin, this.dokter})
    : super(key: key);

  @override
  State<DokterFormPage> createState() => _DokterFormPageState();
}

class _DokterFormPageState extends State<DokterFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaCtrl;
  late TextEditingController _spesialisasiCtrl;
  late TextEditingController _teleponCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _fotoCtrl;

  @override
  void initState() {
    super.initState();
    final d = widget.dokter;
    _namaCtrl = TextEditingController(text: d?.nama ?? '');
    _spesialisasiCtrl = TextEditingController(text: d?.spesialisasi ?? '');
    _teleponCtrl = TextEditingController(text: d?.telepon ?? '');
    _emailCtrl = TextEditingController(text: d?.email ?? '');
    _fotoCtrl = TextEditingController(text: d?.fotoUrl ?? '');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (file != null) {
      final bytes = await file.readAsBytes();
      final base64Data = base64Encode(bytes);
      final dataUrl =
          'data:image/${file.path.split('.').last};base64,$base64Data';
      setState(() {
        _fotoCtrl.text = dataUrl;
      });
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _spesialisasiCtrl.dispose();
    _teleponCtrl.dispose();
    _emailCtrl.dispose();
    _fotoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final doc = Dokter(
      id: widget.dokter?.id,
      nama: _namaCtrl.text.trim(),
      spesialisasi: _spesialisasiCtrl.text.trim(),
      telepon: _teleponCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      fotoUrl: _fotoCtrl.text.trim(),
    );
    try {
      if (widget.dokter == null) {
        final created = await widget.jsonbin.createDokter(doc);
        Navigator.of(context).pop(created);
      } else {
        final updated = await widget.jsonbin.updateDokter(
          widget.dokter!.id!,
          doc,
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
        title: Text(widget.dokter == null ? 'Tambah Dokter' : 'Edit Dokter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _namaCtrl,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Nama wajib diisi'
                              : null,
                ),
                TextFormField(
                  controller: _spesialisasiCtrl,
                  decoration: const InputDecoration(labelText: 'Spesialisasi'),
                ),
                TextFormField(
                  controller: _teleponCtrl,
                  decoration: const InputDecoration(labelText: 'Telepon'),
                ),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _fotoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'URL Foto (opsional) atau pilih gambar',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo),
                      label: const Text('Pilih Foto'),
                      onPressed: _pickImage,
                    ),
                    const SizedBox(width: 12),
                    if (_fotoCtrl.text.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: _buildPreview(_fotoCtrl.text),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _save, child: const Text('Simpan')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(String url) {
    if (url.startsWith('data:')) {
      try {
        final base64Str = url.substring(url.indexOf(',') + 1);
        final bytes = base64Decode(base64Str);
        return Image.memory(bytes, height: 64, width: 64, fit: BoxFit.cover);
      } catch (_) {
        return const SizedBox();
      }
    }
    return Image.network(
      url,
      height: 64,
      width: 64,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox(),
    );
  }
}
