# JSONBin Setup Guide

Aplikasi Klinik sekarang menggunakan **JSONBin.io** sebagai backend untuk menyimpan dan mengakses data. JSONBin unlimited data di free tier sehingga perfect untuk mengatasi constraint MockAPI.

## 1. Setup JSONBin Account

1. Buka https://jsonbin.io
2. Klik **"Create Bin"** (tanpa perlu login)
3. Paste JSON data di bawah ini ke dalam editor

```json
{
  "dokter": [
    {"id": "1", "nama": "Dr. Ahmad Wijaya", "spesialisasi": "Umum", "fotoUrl": "https://via.placeholder.com/150", "telepon": "081234567890", "email": "ahmad@klinik.com"},
    {"id": "2", "nama": "Dr. Siti Nurhaliza", "spesialisasi": "Gigi", "fotoUrl": "https://via.placeholder.com/150", "telepon": "082345678901", "email": "siti@klinik.com"},
    {"id": "3", "nama": "Dr. Budi Santoso", "spesialisasi": "Mata", "fotoUrl": "https://via.placeholder.com/150", "telepon": "083456789012", "email": "budi@klinik.com"}
  ],
  "pasien": [
    {"id": "1", "nama": "Rina Kusuma", "tanggalLahir": "1995-03-15", "telepon": "081111111111", "alamat": "Jalan Merdeka No 10, Jakarta"},
    {"id": "2", "nama": "Budi Hartono", "tanggalLahir": "1990-07-22", "telepon": "082222222222", "alamat": "Jalan Ahmad Yani No 5, Bandung"},
    {"id": "3", "nama": "Ani Setiawan", "tanggalLahir": "1998-11-08", "telepon": "083333333333", "alamat": "Jalan Sudirman No 20, Surabaya"}
  ],
  "pegawai": [
    {"id": "1", "nama": "Ibu Siti Admin", "peran": "pegawai", "telepon": "081000000001"},
    {"id": "2", "nama": "Pak Rudi Rekepsionis", "peran": "pegawai", "telepon": "081000000002"}
  ],
  "reservasi": [
    {"id": "1", "dokterIdId": "1", "pasienId": "1", "tanggalWaktu": "2025-12-15T10:00:00.000Z", "status": "pending"},
    {"id": "2", "dokterIdId": "2", "pasienId": "2", "tanggalWaktu": "2025-12-16T14:00:00.000Z", "status": "confirmed"}
  ],
  "pembayaran": [
    {"id": "1", "reservasiId": "1", "jumlah": 100000, "metode": "cash", "status": "paid", "waktu": "2025-12-15T10:30:00.000Z"},
    {"id": "2", "reservasiId": "2", "jumlah": 150000, "metode": "debit", "status": "pending", "waktu": "2025-12-16T14:30:00.000Z"}
  ],
  "users": [
    {"id": "1", "username": "pegawai1", "password": "secret", "role": "pegawai"},
    {"id": "2", "username": "dokter1", "password": "secret", "role": "dokter"},
    {"id": "3", "username": "pasien1", "password": "secret", "role": "pasien"}
  ]
}
```

4. Klik **"Save as Secret Bin"**
5. Copy **Bin ID** dari URL (format: `https://api.jsonbin.io/v3/b/{BIN_ID}`)
6. Klik profile icon → **"View API Key"** atau buka https://jsonbin.io/account/keys
7. Copy **Master Key**

## 2. Update Flutter Configuration

Edit file `lib/widget/sidebar.dart` baris 13-17:

```dart
  // JSONBin configuration - Ganti dengan Bin ID dan Master Key Anda
  const binId = 'YOUR_JSONBIN_ID';
  const masterKey = 'YOUR_JSONBIN_MASTER_KEY';
  final jsonbinService = JsonbinService(
    binId: binId,
    masterKey: masterKey,
  );
```

**Ganti:**
- `YOUR_JSONBIN_ID` dengan Bin ID dari step 5
- `YOUR_JSONBIN_MASTER_KEY` dengan Master Key dari step 7

## 3. Service Architecture

### JsonbinService (`lib/service/jsonbin_service.dart`)

Service ini menangani semua CRUD operations:

```dart
// Dokter
Future<List<Dokter>> getDokter()
Future<Dokter> createDokter(Dokter d)
Future<Dokter> updateDokter(String id, Dokter d)
Future<void> deleteDokter(String id)

// Pasien
Future<List<Pasien>> getPasien()
Future<Pasien> createPasien(Pasien p)
Future<Pasien> updatePasien(String id, Pasien p)
Future<void> deletePasien(String id)

// Pegawai
Future<List<Pegawai>> getPegawai()
Future<Pegawai> createPegawai(Pegawai s)
Future<Pegawai> updatePegawai(String id, Pegawai s)
Future<void> deletePegawai(String id)

// Reservasi
Future<List<Reservasi>> getReservasi()
Future<Reservasi> createReservasi(Reservasi r)
Future<Reservasi> updateReservasi(String id, Reservasi r)
Future<void> deleteReservasi(String id)

// Pembayaran
Future<List<Pembayaran>> getPembayaran()
Future<Pembayaran> createPembayaran(Pembayaran p)
Future<Pembayaran> updatePembayaran(String id, Pembayaran p)
Future<void> deletePembayaran(String id)

// Authentication
Future<bool> login(String username, String password)
Future<Map<String, dynamic>?> getUserByUsername(String username)
```

## 4. Data Models

Semua data di JSONBin mengikuti struktur model:

### Dokter
- `id`: string (auto-increment)
- `nama`: string
- `spesialisasi`: string
- `fotoUrl`: string (base64 data-URL atau URL)
- `telepon`: string
- `email`: string

### Pasien
- `id`: string (auto-increment)
- `nama`: string
- `tanggalLahir`: string (YYYY-MM-DD)
- `telepon`: string
- `alamat`: string

### Pegawai
- `id`: string (auto-increment)
- `nama`: string
- `peran`: string ("pegawai" / "dokter" / "pasien")
- `telepon`: string

### Reservasi
- `id`: string (auto-increment)
- `dokterIdId`: string (FK ke dokter.id)
- `pasienId`: string (FK ke pasien.id)
- `tanggalWaktu`: string (ISO 8601 datetime)
- `status`: string ("pending" / "confirmed" / "completed" / "cancelled")

### Pembayaran
- `id`: string (auto-increment)
- `reservasiId`: string (FK ke reservasi.id)
- `jumlah`: number (Rp)
- `metode`: string ("cash" / "debit" / "transfer")
- `status`: string ("pending" / "paid" / "failed")
- `waktu`: string (ISO 8601 datetime)

### Users
- `id`: string
- `username`: string
- `password`: string
- `role`: string ("pegawai" / "dokter" / "pasien")

## 5. Role-Based Access Control

### Pegawai (Admin)
- ✅ CRUD Dokter
- ✅ CRUD Pasien
- ✅ CRUD Pegawai
- ✅ CRUD Reservasi
- ✅ CRUD Pembayaran
- ✅ View Laporan

### Dokter
- ❌ CRUD Dokter
- ✅ View Pasien
- ✅ View Reservasi (milik saya)
- ✅ Update Reservasi Status
- ❌ CRUD Pembayaran

### Pasien
- ❌ CRUD Dokter (View only)
- ❌ CRUD Pasien (View own only)
- ✅ Create Reservasi
- ✅ View Reservasi (milik saya)
- ❌ CRUD Pembayaran

## 6. Development Notes

### Features Implemented
✅ Dokter List + Create + Edit + Delete + Photo Upload  
✅ Pasien List + Create + Edit + Delete  
✅ Pegawai List + Create + Edit + Delete  
✅ Reservasi List + Create + Edit + Delete (with doctor/patient dropdown)  
✅ Pembayaran List + Create + Edit + Delete  
✅ API Login (hardcoded fallback)  
✅ Sidebar Navigation  
✅ Image Picker (base64 encoding)  

### Features Planned
⏳ Role-based UI (sidebar menu filtering)  
⏳ Payment Dashboard  
⏳ Report/Statistics  
⏳ Doctor Schedule Management  

### API Endpoints (JSONBin)
- Base: `https://api.jsonbin.io/v3/b/{binId}`
- All data stored in single bin: `record.dokter`, `record.pasien`, `record.pegawai`, `record.reservasi`, `record.pembayaran`, `record.users`
- Headers:
  - `Content-Type: application/json`
  - `X-Master-Key: {masterKey}`

### Known Issues
- Image stored as base64 data-URL (large payloads for photos)
- All data modeled with string IDs (for JSONBin compatibility)
- No automatic ID generation (manual increment in service)

### Debugging Tips
1. Check JSONBin bin content: https://jsonbin.io/v3/b/{binId}/latest
2. Verify master key is correct (403 = wrong key)
3. Check model serialization in `toJson()` methods
4. Test login with credentials: pegawai1/secret, dokter1/secret, pasien1/secret

## 7. Next Steps

1. ✅ Replace MockAPI with JSONBin
2. ⏳ Implement role-based menu filtering in sidebar
3. ⏳ Create Pembayaran UI (list + form)
4. ⏳ Add Payment Dashboard
5. ⏳ Add Statistics/Reports
6. ⏳ Doctor Schedule Calendar
7. ⏳ Push Notification for Reservasi
