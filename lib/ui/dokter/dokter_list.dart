import 'package:flutter/material.dart';
import '../../model/dokter.dart';
import '../../service/jsonbin_service.dart';
import 'dokter_form.dart';

class DokterListPage extends StatefulWidget {
  final JsonbinService jsonbin;
  const DokterListPage({Key? key, required this.jsonbin}) : super(key: key);

  @override
  State<DokterListPage> createState() => _DokterListPageState();
}

class _DokterListPageState extends State<DokterListPage> {
  late Future<List<Dokter>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.jsonbin.getDokter();
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
      appBar: AppBar(title: const Text('Daftar Dokter')),
      body: FutureBuilder<List<Dokter>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final dokter = snapshot.data ?? [];
          if (dokter.isEmpty)
            return Center(child: Text('Belum ada data dokter'));
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: dokter.length,
              itemBuilder: (context, i) {
                final d = dokter[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        d.fotoUrl != null && d.fotoUrl!.isNotEmpty
                            ? NetworkImage(d.fotoUrl!)
                            : null,
                    child:
                        (d.fotoUrl == null || d.fotoUrl!.isEmpty)
                            ? Text(d.nama.isNotEmpty ? d.nama[0] : '?')
                            : null,
                  ),
                  title: Text(d.nama),
                  subtitle: Text(d.spesialisasi ?? '-'),
                  onTap: () async {
                    // open edit form
                    final updated = await Navigator.of(context).push<Dokter>(
                      MaterialPageRoute(
                        builder:
                            (_) => DokterFormPage(
                              jsonbin: widget.jsonbin,
                              dokter: d,
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
          final newDokter = await Navigator.of(context).push<Dokter>(
            MaterialPageRoute(
              builder: (_) => DokterFormPage(jsonbin: widget.jsonbin),
            ),
          );
          if (newDokter != null) _refresh();
        },
      ),
    );
  }
}
