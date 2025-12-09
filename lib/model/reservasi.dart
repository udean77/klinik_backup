class Reservasi {
  final String? id;
  final String dokterIdId;
  final String pasienId;
  final String tanggalWaktu; // ISO datetime
  final String? status; // e.g., pending, confirmed, cancelled

  Reservasi({
    this.id,
    required this.dokterIdId,
    required this.pasienId,
    required this.tanggalWaktu,
    this.status,
  });

  factory Reservasi.fromJson(Map<String, dynamic> json) => Reservasi(
    id: json['id']?.toString(),
    dokterIdId: json['dokterIdId']?.toString() ?? '',
    pasienId: json['pasienId']?.toString() ?? '',
    tanggalWaktu: json['tanggalWaktu'] ?? '',
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'dokterIdId': dokterIdId,
    'pasienId': pasienId,
    'tanggalWaktu': tanggalWaktu,
    'status': status,
  };
}
