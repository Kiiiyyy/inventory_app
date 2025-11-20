import 'package:flutter/material.dart';
import '../../models/barang_model.dart';

class BarangDetail extends StatelessWidget {
  final Barang barang;

  const BarangDetail({Key? key, required this.barang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: Colors.blue[800],
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      barang.namaBarang,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kode: ${barang.kodeBarang}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Barang',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Kode Barang', barang.kodeBarang),
                    _buildDetailRow('Nama Barang', barang.namaBarang),
                    _buildDetailRow(
                      'Stok',
                      '${barang.stok}',
                      valueColor: barang.stok > 0 ? Colors.green : Colors.red,
                    ),
                    _buildDetailRow('Harga Beli', 'Rp ${barang.hargaBeli.toStringAsFixed(0)}'),
                    _buildDetailRow('Harga Jual', 'Rp ${barang.hargaJual.toStringAsFixed(0)}', 
                      valueColor: Colors.green),
                    if (barang.rak != null && barang.rak!.isNotEmpty)
                      _buildDetailRow('Rak/Lokasi', barang.rak!),
                    _buildDetailRow('Kategori', barang.kategori?.namaKategori ?? barang.kodeKategori),
                    _buildDetailRow('Satuan', barang.satuan?.namaSatuan ?? barang.kodeSatuan),
                  ],
                ),
              ),
            ),
            // Profit Information
            if (barang.hargaJual > barang.hargaBeli)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Keuntungan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildProfitRow('Laba per Unit', 'Rp ${(barang.hargaJual - barang.hargaBeli).toStringAsFixed(0)}'),
                      _buildProfitRow('Total Nilai Stok', 'Rp ${(barang.stok * barang.hargaJual).toStringAsFixed(0)}'),
                      _buildProfitRow('Total Potensi Laba', 'Rp ${(barang.stok * (barang.hargaJual - barang.hargaBeli)).toStringAsFixed(0)}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}