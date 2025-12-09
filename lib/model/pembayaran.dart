class Pembayaran {
  final String? id;
  final String reservasiId;
  final double jumlah;
  final String? metode; // e.g., cash, card
  final String? status; // e.g., paid, pending
  final String? waktu; // ISO datetime

  Pembayaran({
    this.id,
    required this.reservasiId,
    required this.jumlah,
    this.metode,
    this.status,
    this.waktu,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
    id: json['id']?.toString(),
    reservasiId: json['reservasiId']?.toString() ?? '',
    jumlah:
        (json['jumlah'] is num)
            ? (json['jumlah'] as num).toDouble()
            : double.tryParse(json['jumlah']?.toString() ?? '0') ?? 0.0,
    metode: json['metode'],
    status: json['status'],
    waktu: json['waktu'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'reservasiId': reservasiId,
    'jumlah': jumlah,
    'metode': metode,
    'status': status,
    'waktu': waktu,
  };
}
