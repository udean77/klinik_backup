import 'package:flutter/material.dart';
import '../../helpers/jsonbin_config.dart';

class JsonbinSettingsPage extends StatefulWidget {
  const JsonbinSettingsPage({Key? key}) : super(key: key);

  @override
  State<JsonbinSettingsPage> createState() => _JsonbinSettingsPageState();
}

class _JsonbinSettingsPageState extends State<JsonbinSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _binCtrl = TextEditingController();
  final _masterCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bin = await JsonbinConfig.getBinId();
    final master = await JsonbinConfig.getMasterKey();
    _binCtrl.text = bin ?? '';
    _masterCtrl.text = master ?? '';
    setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await JsonbinConfig.setBinId(_binCtrl.text.trim());
    await JsonbinConfig.setMasterKey(_masterCtrl.text.trim());
    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved')));
    // return to caller indicating success so the caller can continue (e.g. open Dokter page)
    Navigator.of(context).pop(true);
  }

  Future<void> _testConnection() async {
    final svc = await JsonbinConfig.getService();
    if (svc == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill both Bin ID and Master Key')),
      );
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Testing...')));
    try {
      final list = await svc.getDokter();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OK — dokter count: ${list.length}')),
      );
      // keep on the page; caller will not be automatically navigated. If you want auto-close after test, uncomment below.
      // Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Connection failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JSONBin Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _binCtrl,
                decoration: const InputDecoration(labelText: 'Bin ID'),
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _masterCtrl,
                decoration: const InputDecoration(labelText: 'Master Key'),
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child:
                        _saving
                            ? const CircularProgressIndicator()
                            : const Text('Save'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _testConnection,
                    child: const Text('Test Connection'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await JsonbinConfig.clear();
                  _binCtrl.clear();
                  _masterCtrl.clear();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Cleared')));
                  setState(() {});
                },
                child: const Text('Clear saved config'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
