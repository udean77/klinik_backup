import 'package:flutter/material.dart';
import '../../model/pasien.dart';
import '../../service/jsonbin_service.dart';
import 'pasien_form.dart';

class PasienListPage extends StatefulWidget {
  final JsonbinService jsonbin;
  const PasienListPage({Key? key, required this.jsonbin}) : super(key: key);

  @override
  State<PasienListPage> createState() => _PasienListPageState();
}

class _PasienListPageState extends State<PasienListPage> {
  late Future<List<Pasien>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.jsonbin.getPasien();
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
      appBar: AppBar(title: const Text('Daftar Pasien')),
      body: FutureBuilder<List<Pasien>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final items = snapshot.data ?? [];
          if (items.isEmpty)
            return Center(child: Text('Belum ada data pasien'));
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final p = items[i];
                return ListTile(
                  title: Text(p.nama),
                  subtitle: Text(p.telepon ?? '-'),
                  onTap: () async {
                    final updated = await Navigator.of(context).push<Pasien>(
                      MaterialPageRoute(
                        builder:
                            (_) => PasienFormPage(
                              jsonbin: widget.jsonbin,
                              pasien: p,
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
          final newItem = await Navigator.of(context).push<Pasien>(
            MaterialPageRoute(
              builder: (_) => PasienFormPage(jsonbin: widget.jsonbin),
            ),
          );
          if (newItem != null) _refresh();
        },
      ),
    );
  }
}
