import 'package:flutter/material.dart';
import '../../model/pegawai.dart';
import '../../service/jsonbin_service.dart';
import 'pegawai_form.dart';

class PegawaiListPage extends StatefulWidget {
  final JsonbinService jsonbin;
  const PegawaiListPage({Key? key, required this.jsonbin}) : super(key: key);

  @override
  State<PegawaiListPage> createState() => _PegawaiListPageState();
}

class _PegawaiListPageState extends State<PegawaiListPage> {
  late Future<List<Pegawai>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.jsonbin.getPegawai();
  }

  Future<void> _refresh() async {
    setState(() {
      _load();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pegawai')),
      body: FutureBuilder<List<Pegawai>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final items = snapshot.data ?? [];
          if (items.isEmpty)
            return Center(child: Text('Belum ada data pegawai'));
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final p = items[i];
                return ListTile(
                  title: Text(p.nama),
                  subtitle: Text(p.peran ?? '-'),
                  onTap: () async {
                    final updated = await Navigator.of(context).push<Pegawai>(
                      MaterialPageRoute(
                        builder:
                            (_) => PegawaiFormPage(
                              jsonbin: widget.jsonbin,
                              pegawai: p,
                            ),
                      ),
                    );
                    if (updated != null) _refresh();
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newItem = await Navigator.of(context).push<Pegawai>(
            MaterialPageRoute(
              builder: (_) => PegawaiFormPage(jsonbin: widget.jsonbin),
            ),
          );
          if (newItem != null) _refresh();
        },
      ),
    );
  }
}
