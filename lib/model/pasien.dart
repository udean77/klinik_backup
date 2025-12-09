class Pasien {
  final String? id;
  final String nama;
  final String? tanggalLahir; // ISO date string
  final String? telepon;
  final String? alamat;

  Pasien({
    this.id,
    required this.nama,
    this.tanggalLahir,
    this.telepon,
    this.alamat,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
    id: json['id']?.toString(),
    nama: json['nama'] ?? '',
    tanggalLahir: json['tanggalLahir'],
    telepon: json['telepon'],
    alamat: json['alamat'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'nama': nama,
    'tanggalLahir': tanggalLahir,
    'telepon': telepon,
    'alamat': alamat,
  };
}
