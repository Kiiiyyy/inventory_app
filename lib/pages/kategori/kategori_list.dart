import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/kategori_model.dart';
import 'kategori_form.dart';
import '../barang/barang_list.dart';

class KategoriList extends StatefulWidget {
  const KategoriList({Key? key}) : super(key: key);

  @override
  _KategoriListState createState() => _KategoriListState();
}

class _KategoriListState extends State<KategoriList> {
  late Future<KategoriResponse> _futureKategori;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadKategori();
  }

  void _loadKategori() {
    setState(() {
      _futureKategori = _apiService.getKategori();
    });
  }

  void _showDeleteDialog(Kategori kategori) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Hapus Kategori'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anda akan menghapus kategori:',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kategori.namaKategori,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'Kode: ${kategori.kodeKategori}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tindakan ini tidak dapat dibatalkan. Yakin ingin menghapus?',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteKategori(kategori);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ya, Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteKategori(Kategori kategori) async {
    try {
      final response = await _apiService.deleteKategori(kategori.kodeKategori);
      
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(response.message)),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadKategori();
      } else {
        // Check if it's a constraint violation error
        if (_isConstraintError(response.message)) {
          _showConstraintErrorDialog(kategori);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(response.message)),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Error: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _isConstraintError(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('foreign key constraint') ||
           lowerMessage.contains('masih digunakan') ||
           lowerMessage.contains('tidak dapat dihapus') ||
           lowerMessage.contains('constraint violation') ||
           lowerMessage.contains('integrity constraint') ||
           lowerMessage.contains('barang') ||
           lowerMessage.contains('data terkait');
  }

  void _showConstraintErrorDialog(Kategori kategori) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange[800],
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Tidak Dapat Dihapus',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kategori "${kategori.namaKategori}" sedang digunakan oleh data barang.',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Solusi:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sebelum menghapus kategori, pastikan tidak ada barang yang menggunakan kategori ini.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Anda dapat:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              _buildSolutionStep('1. Lihat daftar barang yang menggunakan kategori ini', Icons.visibility),
              _buildSolutionStep('2. Ubah kategori barang ke kategori lain', Icons.swap_horiz),
              _buildSolutionStep('3. Hapus barang yang masih menggunakan kategori ini', Icons.delete_forever),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToBarangWithKategori(kategori);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2, size: 18),
                  SizedBox(width: 4),
                  Text('Lihat Barang'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSolutionStep(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToBarangWithKategori(Kategori kategori) {
    // Navigate to barang list with this kategori filter
    // This assumes you have a BarangList that accepts filter parameters
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.inventory_2, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Menampilkan barang dengan kategori: ${kategori.namaKategori}'),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Buka',
          textColor: Colors.white,
          onPressed: () {
            _openBarangWithKategoriFilter(kategori);
          },
        ),
      ),
    );

    // Also open directly
    _openBarangWithKategoriFilter(kategori);
  }

  void _openBarangWithKategoriFilter(Kategori kategori) {
    // Implement navigation to barang list with kategori filter
    // This is an example - adjust based on your app structure
    
    // Option 1: Using Navigator (if you have BarangList page)

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarangList(),
      ),
    );

    // Option 2: Show dialog for now (temporary solution)
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Row(
    //         children: [
    //           const Icon(Icons.inventory_2, color: Colors.blue),
    //           const SizedBox(width: 8),
    //           Text('Barang - ${kategori.namaKategori}'),
    //         ],
    //       ),
    //       content: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             'Kategori: ${kategori.namaKategori}',
    //             style: const TextStyle(fontWeight: FontWeight.bold),
    //           ),
    //           Text('Kode: ${kategori.kodeKategori}'),
    //           const SizedBox(height: 16),
    //           const Text(
    //             'Fitur ini akan menampilkan semua barang yang menggunakan kategori ini.',
    //             style: TextStyle(color: Colors.grey),
    //           ),
    //           const SizedBox(height: 8),
    //           Container(
    //             padding: const EdgeInsets.all(12),
    //             decoration: BoxDecoration(
    //               color: Colors.orange[50],
    //               borderRadius: BorderRadius.circular(8),
    //             ),
    //             child: const Row(
    //               children: [
    //                 Icon(Icons.build, color: Colors.orange, size: 16),
    //                 SizedBox(width: 8),
    //                 Expanded(
    //                   child: Text(
    //                     'Halaman barang dengan filter perlu diimplementasikan',
    //                     style: TextStyle(fontSize: 12, color: Colors.orange),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: const Text('Tutup'),
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //             // Navigate to general barang list
    //             _navigateToBarangList();
    //           },
    //           child: const Text('Buka Daftar Barang'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void _navigateToBarangList() {
    // Navigate to general barang list (without filter)
    // This assumes your dashboard has navigation
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.arrow_forward, color: Colors.white),
            SizedBox(width: 8),
            Text('Navigasi ke halaman barang...'),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
    );

    // Example navigation - adjust based on your app structure
    // Navigator.pushNamed(context, '/barang');
    // or change dashboard tab index if using bottom navigation
  }

  Widget _buildKategoriCard(Kategori kategori) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.category,
                color: Colors.green[800],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategori.namaKategori,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kode: ${kategori.kodeKategori}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  if (kategori.createdAt != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Dibuat: ${_formatDate(kategori.createdAt!)}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KategoriForm(
                        kategori: kategori,
                        onSaved: _loadKategori,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeleteDialog(kategori);
                } else if (value == 'view_items') {
                  _navigateToBarangWithKategori(kategori);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'view_items',
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text('Lihat Barang'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Hapus'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadKategori,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Memuat data kategori...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.category_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Kategori',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mulai dengan menambahkan kategori pertama Anda',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KategoriForm(onSaved: _loadKategori),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Kategori Pertama'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kategori'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadKategori,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: FutureBuilder<KategoriResponse>(
        future: _futureKategori,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return _buildErrorWidget('Tidak ada data yang diterima');
          }

          final response = snapshot.data!;
          
          if (!response.success) {
            return _buildErrorWidget(response.message);
          }

          if (response.data == null || response.data!.isEmpty) {
            return _buildEmptyWidget();
          }

          final kategoriList = response.data!;

          return Column(
            children: [
              // Header info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.green[100]!),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.category, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${kategoriList.length} Kategori',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Total kategori dalam sistem',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadKategori();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: kategoriList.length,
                    itemBuilder: (context, index) {
                      final kategori = kategoriList[index];
                      return _buildKategoriCard(kategori);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KategoriForm(onSaved: _loadKategori),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}