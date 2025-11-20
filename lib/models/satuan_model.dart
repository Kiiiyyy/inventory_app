class Satuan {
  final String kodeSatuan;
  final String namaSatuan;
  final String? createdAt;
  final String? updatedAt;

  Satuan({
    required this.kodeSatuan,
    required this.namaSatuan,
    this.createdAt,
    this.updatedAt,
  });

  factory Satuan.fromJson(Map<String, dynamic> json) {
    return Satuan(
      kodeSatuan: json['kode_satuan']?.toString() ?? '',
      namaSatuan: json['nama_satuan']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_satuan': kodeSatuan,
      'nama_satuan': namaSatuan,
    };
  }
}

class SatuanResponse {
  final bool success;
  final String message;
  final List<Satuan>? data;
  final Map<String, dynamic>? errors;

  SatuanResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory SatuanResponse.fromJson(Map<String, dynamic> json) {
    List<Satuan>? dataList;
    
    if (json['data'] != null) {
      if (json['data'] is List) {
        dataList = (json['data'] as List).map((item) {
          return Satuan.fromJson(item);
        }).toList();
      }
    }

    return SatuanResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: dataList,
      errors: json['errors'] is Map ? Map<String, dynamic>.from(json['errors']) : null,
    );
  }
}