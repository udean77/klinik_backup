class Pegawai {
  final String? id;
  final String nama;
  final String? peran;
  final String? telepon;

  Pegawai({this.id, required this.nama, this.peran, this.telepon});

  factory Pegawai.fromJson(Map<String, dynamic> json) => Pegawai(
    id: json['id']?.toString(),
    nama: json['nama'] ?? '',
    peran: json['peran'],
    telepon: json['telepon'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'nama': nama,
    'peran': peran,
    'telepon': telepon,
  };
}
