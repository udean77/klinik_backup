import 'package:flutter/material.dart';
import '../ui/beranda.dart';
import '../ui/login.dart';
import '../ui/poli/poli_page.dart';
import '../ui/dokter/dokter_list.dart';
import '../service/jsonbin_service.dart';
import '../helpers/jsonbin_config.dart';
import '../helpers/user_info.dart';
import '../ui/settings/settings_page.dart';
import '../ui/pasien/pasien_list.dart';
import '../ui/pegawai/pegawai_list.dart';
import '../ui/reservasi/reservasi_list.dart';
import '../ui/pembayaran/pembayaran_list.dart';
import '../ui/pasien/pasien_reservasi.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await UserInfo().getUserRole();
    setState(() => _userRole = role);
  }

  @override
  Widget build(BuildContext context) {
    // JSONBin configuration is stored in app settings (Settings page)

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<String?>(
              future: UserInfo().getUsername(),
              builder: (context, snap) => Text(snap.data ?? 'User'),
            ),
            accountEmail: FutureBuilder<String?>(
              future: UserInfo().getUserRole(),
              builder: (context, snap) => Text('Role: ${snap.data ?? '?'}'),
            ),
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
          if (_userRole != 'pasien')
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
          // Dokter menu - visible to pegawai, dokter, pasien
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text("Dokter"),
            onTap: () async {
              var svc = await JsonbinConfig.getService();
              if (svc == null) {
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const JsonbinSettingsPage(),
                  ),
                );
                if (res == true) {
                  svc = await JsonbinConfig.getService();
                }
              }
              if (svc == null) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DokterListPage(jsonbin: svc!),
                ),
              );
            },
          ),
          // Pegawai menu - only for pegawai
          if (_userRole == 'pegawai')
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Pegawai"),
              onTap: () async {
                var svc = await JsonbinConfig.getService();
                if (svc == null) {
                  final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JsonbinSettingsPage(),
                    ),
                  );
                  if (res == true) {
                    svc = await JsonbinConfig.getService();
                  }
                }
                if (svc == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PegawaiListPage(jsonbin: svc!),
                  ),
                );
              },
            ),
          // Pasien menu - only for pegawai
          if (_userRole == 'pegawai')
            ListTile(
              leading: const Icon(Icons.account_box_sharp),
              title: const Text("Pasien"),
              onTap: () async {
                var svc = await JsonbinConfig.getService();
                if (svc == null) {
                  final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JsonbinSettingsPage(),
                    ),
                  );
                  if (res == true) {
                    svc = await JsonbinConfig.getService();
                  }
                }
                if (svc == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasienListPage(jsonbin: svc!),
                  ),
                );
              },
            ),
          // Reservasi menu - different versions per role
          if (_userRole == 'pasien')
            // Pasien: use simplified pasien_reservasi page
            ListTile(
              leading: const Icon(Icons.event_note),
              title: const Text("Buat Reservasi"),
              onTap: () async {
                var svc = await JsonbinConfig.getService();
                if (svc == null) {
                  final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JsonbinSettingsPage(),
                    ),
                  );
                  if (res == true) {
                    svc = await JsonbinConfig.getService();
                  }
                }
                if (svc == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasienReservasiPage(jsonbin: svc!),
                  ),
                );
              },
            )
          else
            // Pegawai/Dokter: use full reservasi list
            ListTile(
              leading: const Icon(Icons.event_note),
              title: const Text("Reservasi"),
              onTap: () async {
                var svc = await JsonbinConfig.getService();
                if (svc == null) {
                  final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JsonbinSettingsPage(),
                    ),
                  );
                  if (res == true) {
                    svc = await JsonbinConfig.getService();
                  }
                }
                if (svc == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservasiListPage(jsonbin: svc!),
                  ),
                );
              },
            ),
          // Pembayaran menu - only for pegawai
          if (_userRole == 'pegawai')
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text("Pembayaran"),
              onTap: () async {
                var svc = await JsonbinConfig.getService();
                if (svc == null) {
                  final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JsonbinSettingsPage(),
                    ),
                  );
                  if (res == true) {
                    svc = await JsonbinConfig.getService();
                  }
                }
                if (svc == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PembayaranListPage(jsonbin: svc!),
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const JsonbinSettingsPage(),
                  ),
                ),
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
