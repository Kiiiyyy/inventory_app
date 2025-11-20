import 'kategori_model.dart';
import 'satuan_model.dart';
class Barang {
  final String kodeBarang;
  final String namaBarang;
  final int stok;
  final double hargaBeli;
  final double hargaJual;
  final String kodeKategori;
  final String kodeSatuan;
  final String? rak;
  final Kategori? kategori;
  final Satuan? satuan;

  Barang({
    required this.kodeBarang,
    required this.namaBarang,
    required this.stok,
    required this.hargaBeli,
    required this.hargaJual,
    required this.kodeKategori,
    required this.kodeSatuan,
    required this.rak,
    this.kategori,
    this.satuan,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      kodeBarang: json['kode_barang']?.toString() ?? '',
      namaBarang: json['nama_barang']?.toString() ?? '',
      stok: json['stok'] is int ? json['stok'] : int.tryParse(json['stok'].toString()) ?? 0,
      hargaBeli: json['harga_beli'] is double ? json['harga_beli'] : double.tryParse(json['harga_beli'].toString()) ?? 0.0,
      hargaJual: json['harga_jual'] is double ? json['harga_jual'] : double.tryParse(json['harga_jual'].toString()) ?? 0.0,
      kodeKategori: json['kode_kategori']?.toString() ?? '',
      kodeSatuan: json['kode_satuan']?.toString() ?? '',
      rak: json['rak']?.toString(),
      kategori: json['kategori'] != null
          ? Kategori.fromJson(json['kategori'])
          : null,
      satuan: json['satuan'] != null
          ? Satuan.fromJson(json['satuan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode_barang': kodeBarang,
      'nama_barang': namaBarang,
      'stok': stok,
      'harga_beli': hargaBeli,
      'harga_jual': hargaJual,
      'kode_kategori': kodeKategori,
      'kode_satuan': kodeSatuan,
      'rak': rak,
    };
  }
}

class BarangResponse {
  final bool success;
  final String message;
  final List<Barang>? data;
  final Map<String, dynamic>? errors;

  BarangResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory BarangResponse.fromJson(Map<String, dynamic> json) {
    List<Barang>? dataList;
    
    if (json['data'] != null) {
      if (json['data'] is List) {
        dataList = (json['data'] as List).map((item) {
          return Barang.fromJson(item);
        }).toList();
      }
    }

    return BarangResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: dataList,
      errors: json['errors'] is Map ? Map<String, dynamic>.from(json['errors']) : null,
    );
  }
}