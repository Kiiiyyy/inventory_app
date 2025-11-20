import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/barang_model.dart';
import '../models/kategori_model.dart';
import '../models/satuan_model.dart';
import '../models/supplier_model.dart';
import 'auth_service.dart';

class ApiService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      ...ApiConfig.headers,
      'Authorization': 'Bearer $token',
    };
  }
// Barang Methods
Future<BarangResponse> getBarang() async {
  final headers = await _getHeaders();
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/barang'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseBody = json.decode(response.body);
    return BarangResponse.fromJson(responseBody);
  } else {
    throw Exception('Failed to load barang. Status code: ${response.statusCode}');
  }
}

Future<BarangResponse> createBarang(Barang barang) async {
  final headers = await _getHeaders();
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/barang'),
    headers: headers,
    body: json.encode(barang.toJson()),
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return BarangResponse.fromJson(responseBody);
}

Future<BarangResponse> updateBarang(String kodeBarang, Barang barang) async {
  final headers = await _getHeaders();
  final response = await http.put(
    Uri.parse('${ApiConfig.baseUrl}/barang/$kodeBarang'),
    headers: headers,
    body: json.encode(barang.toJson()),
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return BarangResponse.fromJson(responseBody);
}

Future<BarangResponse> deleteBarang(String kodeBarang) async {
  final headers = await _getHeaders();
  final response = await http.delete(
    Uri.parse('${ApiConfig.baseUrl}/barang/$kodeBarang'),
    headers: headers,
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return BarangResponse.fromJson(responseBody);
}
// Kategori Methods
Future<KategoriResponse> getKategori() async {
  final headers = await _getHeaders();
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/kategori'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseBody = json.decode(response.body);
    return KategoriResponse.fromJson(responseBody);
  } else {
    throw Exception('Failed to load kategori. Status code: ${response.statusCode}');
  }
}

Future<KategoriResponse> createKategori(Kategori kategori) async {
  final headers = await _getHeaders();
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/kategori'),
    headers: headers,
    body: json.encode(kategori.toJson()),
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return KategoriResponse.fromJson(responseBody);
}

Future<KategoriResponse> updateKategori(String kodeKategori, Kategori kategori) async {
  final headers = await _getHeaders();
  final response = await http.put(
    Uri.parse('${ApiConfig.baseUrl}/kategori/$kodeKategori'),
    headers: headers,
    body: json.encode(kategori.toJson()),
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return KategoriResponse.fromJson(responseBody);
}

Future<KategoriResponse> deleteKategori(String kodeKategori) async {
  final headers = await _getHeaders();
  final response = await http.delete(
    Uri.parse('${ApiConfig.baseUrl}/kategori/$kodeKategori'),
    headers: headers,
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return KategoriResponse.fromJson(responseBody);
}
// Satuan Methods
Future<SatuanResponse> getSatuan() async {
  final headers = await _getHeaders();
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/satuan'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseBody = json.decode(response.body);
    return SatuanResponse.fromJson(responseBody);
  } else {
    throw Exception('Failed to load satuan. Status code: ${response.statusCode}');
  }
}

Future<SatuanResponse> createSatuan(Satuan satuan) async {
  final headers = await _getHeaders();
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/satuan'),
    headers: headers,
    body: json.encode(satuan.toJson()),
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return SatuanResponse.fromJson(responseBody);
}

Future<SatuanResponse> updateSatuan(String kodeSatuan, Satuan satuan) async {
  final headers = await _getHeaders();
  final response = await http.put(
    Uri.parse('${ApiConfig.baseUrl}/satuan/$kodeSatuan'),
    headers: headers,
    body: json.encode(satuan.toJson()),
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return SatuanResponse.fromJson(responseBody);
}

Future<SatuanResponse> deleteSatuan(String kodeSatuan) async {
  final headers = await _getHeaders();
  final response = await http.delete(
    Uri.parse('${ApiConfig.baseUrl}/satuan/$kodeSatuan'),
    headers: headers,
  );

  final Map<String, dynamic> responseBody = json.decode(response.body);
  return SatuanResponse.fromJson(responseBody);
}
  // Supplier Methods
  Future<SupplierResponse> getSupplier() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/supplier'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return SupplierResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to load supplier. Status code: ${response.statusCode}');
    }
  }

  Future<SupplierResponse> createSupplier(Supplier supplier) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/supplier'),
      headers: headers,
      body: json.encode(supplier.toJson()),
    );

    final Map<String, dynamic> responseBody = json.decode(response.body);
    return SupplierResponse.fromJson(responseBody);
  }

  Future<SupplierResponse> updateSupplier(String kodeSupplier, Supplier supplier) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/supplier/$kodeSupplier'),
      headers: headers,
      body: json.encode(supplier.toJson()),
    );

    final Map<String, dynamic> responseBody = json.decode(response.body);
    return SupplierResponse.fromJson(responseBody);
  }

  Future<SupplierResponse> deleteSupplier(String kodeSupplier) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/supplier/$kodeSupplier'),
      headers: headers,
    );

    final Map<String, dynamic> responseBody = json.decode(response.body);
    return SupplierResponse.fromJson(responseBody);
  }
}