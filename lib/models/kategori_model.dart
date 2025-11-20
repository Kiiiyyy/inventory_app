class Kategori {
  final String kodeKategori;
  final String namaKategori;
  final String? createdAt;
  final String? updatedAt;

  Kategori({
    required this.kodeKategori,
    required this.namaKategori,
    this.createdAt,
    this.updatedAt,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      kodeKategori: json['kode_kategori']?.toString() ?? '',
      namaKategori: json['nama_kategori']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_kategori': kodeKategori,
      'nama_kategori': namaKategori,
    };
  }
}

class KategoriResponse {
  final bool success;
  final String message;
  final List<Kategori>? data;
  final Map<String, dynamic>? errors;

  KategoriResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory KategoriResponse.fromJson(Map<String, dynamic> json) {
    List<Kategori>? dataList;
    
    if (json['data'] != null) {
      if (json['data'] is List) {
        dataList = (json['data'] as List).map((item) {
          return Kategori.fromJson(item);
        }).toList();
      }
    }

    return KategoriResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: dataList,
      errors: json['errors'] is Map ? Map<String, dynamic>.from(json['errors']) : null,
    );
  }
}
