class Kampus {
  final int no;
  final String nama;
  final String alamatLengkap;
  final String noTelepon;
  final String kategori;
  final double latitude;
  final double longitude;
  final String jurusan;

  Kampus({
    required this.no,
    required this.nama,
    required this.alamatLengkap,
    required this.noTelepon,
    required this.kategori,
    required this.latitude,
    required this.longitude,
    required this.jurusan,
  });

  factory Kampus.fromJson(Map<String, dynamic> json) {
    return Kampus(
      no: json['no'],
      nama: json['nama'],
      alamatLengkap: json['alamat_lengkap'],
      noTelepon: json['no_telepon'],
      kategori: json['kategori'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      jurusan: json['jurusan'],
    );
  }

  Map<String, dynamic> toJson() => {
    'no': no,
    'nama': nama,
    'alamat_lengkap': alamatLengkap,
    'no_telepon': noTelepon,
    'kategori': kategori,
    'latitude': latitude,
    'longitude': longitude,
    'jurusan': jurusan,
  };
}
