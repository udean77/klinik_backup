import 'package:flutter/material.dart';
import '../../service/jsonbin_service.dart';
import '../../model/reservasi.dart';
import '../../model/dokter.dart';
import '../../model/pasien.dart';
import 'reservasi_form.dart';

class ReservasiListPage extends StatefulWidget {
  final JsonbinService jsonbin;
  const ReservasiListPage({Key? key, required this.jsonbin}) : super(key: key);

  @override
  _ReservasiListPageState createState() => _ReservasiListPageState();
}

class _ReservasiListPageState extends State<ReservasiListPage> {
  List<Reservasi> _items = [];
  Map<String, Dokter> _doctors = {};
  Map<String, Pasien> _patients = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final r = await widget.jsonbin.getReservasi();
      final dlist = await widget.jsonbin.getDokter();
      final plist = await widget.jsonbin.getPasien();
      setState(() {
        _items = r;
        _doctors = {
          for (var e in dlist)
            if (e.id != null) e.id!: e,
        };
        _patients = {
          for (var e in plist)
            if (e.id != null) e.id!: e,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _delete(String id) async {
    try {
      await widget.jsonbin.deleteReservasi(id);
      await _loadAll();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservasi')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadAll,
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    final doctor = _doctors[item.dokterIdId];
                    final patient = _patients[item.pasienId];
                    return ListTile(
                      title: Text(doctor?.nama ?? 'Dokter: ${item.dokterIdId}'),
                      subtitle: Text(
                        'Pasien: ${patient?.nama ?? item.pasienId}\nTanggal: ${item.tanggalWaktu}\nStatus: ${item.status ?? '-'}',
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) async {
                          if (v == 'edit') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ReservasiFormPage(
                                      jsonbin: widget.jsonbin,
                                      reservasi: item,
                                    ),
                              ),
                            );
                            _loadAll();
                          } else if (v == 'delete' && item.id != null) {
                            _delete(item.id!);
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
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ReservasiFormPage(
                                  jsonbin: widget.jsonbin,
                                  reservasi: item,
                                ),
                          ),
                        );
                        _loadAll();
                      },
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReservasiFormPage(jsonbin: widget.jsonbin),
            ),
          );
          _loadAll();
        },
      ),
    );
  }
}
