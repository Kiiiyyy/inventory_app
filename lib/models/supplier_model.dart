class Supplier {
  final String kodeSuplier;
  final String namaSuplier;
  final String alamat;
  final String phone;
  final String? namaPt;
  final String? fax;
  final String? createdAt;
  final String? updatedAt;

  Supplier({
    required this.kodeSuplier,
    required this.namaSuplier,
    required this.alamat,
    required this.phone,
    this.namaPt,
    this.fax,
    this.createdAt,
    this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      kodeSuplier: json['kode_suplier']?.toString() ?? '',
      namaSuplier: json['nama_suplier']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      namaPt: json['nama_pt']?.toString(),
      fax: json['fax']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_suplier': kodeSuplier,
      'nama_suplier': namaSuplier,
      'alamat': alamat,
      'phone': phone,
      'nama_pt': namaPt,
      'fax': fax,
    };
  }
}

class SupplierResponse {
  final bool success;
  final String message;
  final List<Supplier>? data;
  final Map<String, dynamic>? errors;

  SupplierResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory SupplierResponse.fromJson(Map<String, dynamic> json) {
    List<Supplier>? dataList;
    
    if (json['data'] != null) {
      if (json['data'] is List) {
        dataList = (json['data'] as List).map((item) {
          return Supplier.fromJson(item);
        }).toList();
      }
    }

    return SupplierResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: dataList,
      errors: json['errors'] is Map ? Map<String, dynamic>.from(json['errors']) : null,
    );
  }
}