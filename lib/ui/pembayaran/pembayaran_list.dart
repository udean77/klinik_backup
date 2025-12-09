import 'package:flutter/material.dart';
import '../../model/pembayaran.dart';
import '../../service/jsonbin_service.dart';
import 'pembayaran_form.dart';

class PembayaranListPage extends StatefulWidget {
  final JsonbinService jsonbin;
  const PembayaranListPage({Key? key, required this.jsonbin}) : super(key: key);

  @override
  State<PembayaranListPage> createState() => _PembayaranListPageState();
}

class _PembayaranListPageState extends State<PembayaranListPage> {
  late Future<List<Pembayaran>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = widget.jsonbin.getPembayaran();
  }

  Future<void> _refresh() async {
    setState(() {
      _load();
    });
    await _future;
  }

  Future<void> _delete(String id) async {
    try {
      await widget.jsonbin.deletePembayaran(id);
      await _refresh();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal hapus: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pembayaran')),
      body: FutureBuilder<List<Pembayaran>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final items = snapshot.data ?? [];
          if (items.isEmpty)
            return const Center(child: Text('Belum ada data pembayaran'));
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final p = items[i];
                return ListTile(
                  title: Text('Rp ${p.jumlah.toString()}'),
                  subtitle: Text(
                    'Metode: ${p.metode ?? "-"} | Status: ${p.status ?? "-"}',
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (v) {
                      if (v == 'edit') {
                        Navigator.of(context)
                            .push<Pembayaran>(
                              MaterialPageRoute(
                                builder:
                                    (_) => PembayaranFormPage(
                                      jsonbin: widget.jsonbin,
                                      pembayaran: p,
                                    ),
                              ),
                            )
                            .then((_) => _refresh());
                      } else if (v == 'delete' && p.id != null) {
                        _delete(p.id!);
                      }
                    },
                    itemBuilder:
                        (_) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Hapus'),
                          ),
                        ],
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push<Pembayaran>(
                          MaterialPageRoute(
                            builder:
                                (_) => PembayaranFormPage(
                                  jsonbin: widget.jsonbin,
                                  pembayaran: p,
                                ),
                          ),
                        )
                        .then((_) => _refresh());
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push<Pembayaran>(
                MaterialPageRoute(
                  builder: (_) => PembayaranFormPage(jsonbin: widget.jsonbin),
                ),
              )
              .then((_) => _refresh());
        },
      ),
    );
  }
}
