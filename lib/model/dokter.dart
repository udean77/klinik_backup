class Dokter {
  final String? id;
  final String nama;
  final String? spesialisasi;
  final String? fotoUrl;
  final String? telepon;
  final String? email;

  Dokter({
    this.id,
    required this.nama,
    this.spesialisasi,
    this.fotoUrl,
    this.telepon,
    this.email,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) => Dokter(
    id: json['id']?.toString(),
    nama: json['nama'] ?? '',
    spesialisasi: json['spesialisasi'],
    fotoUrl: json['fotoUrl'],
    telepon: json['telepon'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'nama': nama,
    'spesialisasi': spesialisasi,
    'fotoUrl': fotoUrl,
    'telepon': telepon,
    'email': email,
  };
}
