import 'package:flutter/material.dart';
import '../ui/beranda.dart';
import '../ui/login.dart';
import '../ui/poli/poli_page.dart';
import '../ui/dokter/dokter_list.dart';
import '../service/jsonbin_service.dart';
import '../ui/pasien/pasien_list.dart';
import '../ui/pegawai/pegawai_list.dart';
import '../ui/reservasi/reservasi_list.dart';
import '../ui/pembayaran/pembayaran_list.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // JSONBin configuration - Ganti dengan Bin ID Anda
    const binId = '693899efd0ea881f401dfe2b';
    const masterKey = '69389d0543b1c97be9e2f0ec';
    final jsonbinService = JsonbinService(binId: binId, masterKey: masterKey);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Admin"),
            accountEmail: Text("admin@admin.com"),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Beranda"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Beranda()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.accessible),
            title: const Text("Poli"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PoliPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text("Dokter"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DokterListPage(jsonbin: jsonbinService),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Pegawai"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PegawaiListPage(jsonbin: jsonbinService),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box_sharp),
            title: const Text("Pasien"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PasienListPage(jsonbin: jsonbinService),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_note),
            title: const Text("Reservasi"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ReservasiListPage(jsonbin: jsonbinService),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Pembayaran"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PembayaranListPage(jsonbin: jsonbinService),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text("Keluar"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
