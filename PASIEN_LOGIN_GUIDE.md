# Panduan Login Pasien & Alur Reservasi

## Ringkasan Fitur

Sistem klinik sekarang mendukung **role-based access control (RBAC)** yang membedakan menu dan fitur berdasarkan peran pengguna:

### **Role yang Tersedia:**

1. **Pegawai (pegawai)**
   - Akses penuh ke semua data: Dokter, Pasien, Pegawai, Reservasi, Pembayaran
   - Dapat mengelola semua entitas (Create, Read, Update, Delete)
   - Menu: Beranda, Dokter, Pegawai, Pasien, Reservasi, Pembayaran, Settings, Keluar

2. **Dokter (dokter)**
   - Akses terbatas untuk melihat dokter dan reservasi
   - Dapat melihat reservasi pasien
   - Menu: Beranda, Dokter, Reservasi, Settings, Keluar
   - Tidak bisa: Kelola Pegawai, Pasien, Pembayaran

3. **Pasien (pasien)**
   - Akses khusus untuk melihat dokter dan membuat reservasi
   - Dapat melihat daftar dokter dan membuat janji temu
   - Menu: Beranda, Dokter, **Buat Reservasi**, Settings, Keluar
   - Tidak bisa: Kelola Pegawai, Pasien, Pembayaran

---

## Alur Login Pasien

### **Step 1: Pastikan JSONBin Config Sudah Tersimpan**

Pastikan Bin ID dan Master Key sudah dikonfigurasi melalui **Settings**. Jika belum, tekan salah satu menu dan akan diminta untuk membuka Settings terlebih dahulu.

### **Step 2: Login Sebagai Pasien**

Di halaman **Login**:
- **Username:** `pasien1`
- **Password:** `secret`

Tekan tombol **Login**

### **Step 3: Sistem Otomatis Deteksi Role**

Setelah login berhasil:
1. Aplikasi mengambil role dari JSONBin (`getUserByUsername()`)
2. Role tersimpan di `SharedPreferences` via `UserInfo.setUserRole()`
3. Halaman **Beranda** ditampilkan dengan role yang sudah disimpan

### **Step 4: Menu Spesifik Pasien Muncul**

Di **Sidebar**, Anda akan melihat menu khusus untuk pasien:
- ✅ **Beranda** - Dashboard utama
- ✅ **Dokter** - Lihat daftar dokter yang tersedia
- ✅ **Buat Reservasi** - Halaman sederhana untuk membuat janji temu
- ✅ **Settings** - Ubah konfigurasi JSONBin
- ✅ **Keluar** - Logout

Menu yang **TIDAK** muncul untuk pasien:
- ❌ Poli (tidak relevan)
- ❌ Pegawai (hanya untuk staff)
- ❌ Pasien (hanya untuk staff)
- ❌ Pembayaran (hanya untuk staff)

---

## Cara Membuat Reservasi Sebagai Pasien

### **Step 1: Buka Menu "Buat Reservasi"**

Tekan menu **Buat Reservasi** di sidebar → Halaman dengan form sederhana terbuka

### **Step 2: Isi Form**

1. **Pilih Dokter**
   - Dropdown menampilkan semua dokter yang tersedia
   - Format: `[Nama Dokter] ([Spesialisasi])`
   - Contoh: `Dr. Budi Santoso (Umum)`

2. **Pilih Tanggal & Waktu**
   - Tekan kotak "Pilih tanggal & waktu"
   - **Date Picker** terbuka → pilih tanggal mulai besok hingga 90 hari ke depan
   - **Time Picker** terbuka → pilih jam (default: 10:00)

### **Step 3: Buat Reservasi**

Tekan tombol **Buat Reservasi** → Notifikasi "Reservasi berhasil dibuat" muncul

### **Step 4: Lihat Riwayat Reservasi**

Di bawah form, bagian **"Reservasi Anda"** menampilkan:
- Nama dokter yang direservasi
- Tanggal dan waktu reservasi
- Status reservasi (pending/confirmed/completed)

---

## Data Pasien di JSONBin

### **Users Array untuk Pasien**

```json
{
  "users": [
    {
      "id": "p1",
      "username": "pasien1",
      "password": "secret",
      "role": "pasien"
    },
    {
      "id": "p2",
      "username": "pasien2",
      "password": "secret",
      "role": "pasien"
    }
  ]
}
```

Anda bisa menambah pasien lain dengan struktur serupa di JSONBin.

---

## Akses Role-Based di Sidebar

### **Implementasi Teknis**

File: `lib/widget/sidebar.dart`

```dart
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
```

Setiap menu item memiliki kondisi `if (_userRole == 'pasien')` atau `if (_userRole == 'pegawai')` untuk menampilkan/menyembunyikan menu.

---

## Fitur Khusus Pasien

### **PasienReservasiPage** (`lib/ui/pasien/pasien_reservasi.dart`)

Halaman khusus untuk pasien dengan fitur:

1. **Dropdown Dokter** - Menampilkan semua dokter dari JSONBin
2. **Date & Time Picker** - Memilih tanggal dan waktu reservasi
3. **Create Reservasi** - Menyimpan reservasi ke JSONBin dengan:
   - `dokterIdId`: ID dokter yang dipilih
   - `pasienId`: ID pasien yang sedang login
   - `tanggalWaktu`: ISO 8601 format
   - `status`: "pending" (default)

4. **Riwayat Reservasi** - Menampilkan daftar reservasi milik pasien yang sedang login

---

## Perubahan Kode yang Dibuat

### **1. login.dart**
- Menambahkan `await JsonbinConfig.getService()`
- Memanggil `service.getUserByUsername(username)` untuk mengambil role
- Menyimpan role ke `UserInfo.setUserRole()`

### **2. sidebar.dart**
- Ubah dari `StatelessWidget` → `StatefulWidget`
- Tambah `_loadUserRole()` untuk membaca role dari SharedPreferences
- Kondisional menu berdasarkan role:
  - **Pasien**: Hanya Beranda, Dokter, Buat Reservasi, Settings, Keluar
  - **Pegawai**: Semua menu
  - **Dokter**: Beranda, Dokter, Reservasi, Settings, Keluar

### **3. pasien_reservasi.dart** (File Baru)
- Halaman khusus untuk pasien membuat reservasi
- Dropdown dokter + date/time picker
- Menampilkan riwayat reservasi milik pasien

---

## Testing Checklist

- [ ] Login dengan `pasien1 / secret`
- [ ] Sidebar menampilkan menu khusus pasien (tanpa Pegawai, Pasien, Pembayaran)
- [ ] Tekan "Buat Reservasi" → Halaman PasienReservasiPage terbuka
- [ ] Pilih dokter dari dropdown
- [ ] Pilih tanggal & waktu dengan date/time picker
- [ ] Tekan "Buat Reservasi" → Notifikasi sukses muncul
- [ ] Riwayat reservasi muncul di bawah form
- [ ] Tekan "Keluar" → Kembali ke halaman login

---

## Troubleshooting

### **Menu "Buat Reservasi" tidak muncul**
→ Pastikan sudah login dengan role `pasien` (cek JSONBin users array)

### **Dropdown dokter kosong**
→ Pastikan ada dokter di JSONBin dan Master Key valid

### **Reservasi tidak tersimpan**
→ Cek apakah User ID dan Dokter ID valid di JSONBin

### **Role tidak terubah setelah login**
→ Cek SharedPreferences: Settings → Clear → Login ulang

---

## Credential Default untuk Testing

| Role    | Username | Password | ID  |
|---------|----------|----------|-----|
| Pegawai | pegawai1 | secret   | e1  |
| Dokter  | dokter1  | secret   | d1  |
| Pasien  | pasien1  | secret   | p1  |
| Pasien  | pasien2  | secret   | p2  |

Semua user sudah ada di template JSONBin. Anda bisa menambah user lain dengan pola yang sama.

