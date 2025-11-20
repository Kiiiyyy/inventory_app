import 'package:flutter/material.dart';
import '../barang/barang_list.dart';
import '../kategori/kategori_list.dart';
import '../satuan/satuan_list.dart';
import '../supplier/supplier_list.dart';
import '../../widgets/sidebar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const BarangList(),
    const KategoriList(),
    const SatuanList(),
    const SupplierList(),
  ];

  final List<String> _appBarTitles = [
    'Manajemen Barang',
    'Manajemen Kategori',
    'Manajemen Satuan',
    'Manajemen Supplier',
  ];

  void _onMenuSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Sidebar(
        onMenuSelected: _onMenuSelected,
        selectedIndex: _selectedIndex,
      ),
      body: _pages[_selectedIndex],
    );
  }
}