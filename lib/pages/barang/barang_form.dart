import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/barang_model.dart';
import '../../models/kategori_model.dart';
import '../../models/satuan_model.dart';
import '../../widgets/custom_textfield.dart';

class BarangForm extends StatefulWidget {
  final Barang? barang;
  final Function() onSaved;

  const BarangForm({
    Key? key,
    this.barang,
    required this.onSaved,
  }) : super(key: key);

  @override
  _BarangFormState createState() => _BarangFormState();
}

class _BarangFormState extends State<BarangForm> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  
  late TextEditingController _kodeBarangController;
  late TextEditingController _namaBarangController;
  late TextEditingController _stokController;
  late TextEditingController _hargaBeliController;
  late TextEditingController _hargaJualController;
  late TextEditingController _rakController;
  
  String? _selectedKategori;
  String? _selectedSatuan;
  
  List<Kategori> _kategoriList = [];
  List<Satuan> _satuanList = [];
  
  bool _isLoading = false;
  bool _isEdit = false;
  bool _isLoadingDropdown = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.barang != null;
    
    _kodeBarangController = TextEditingController(text: widget.barang?.kodeBarang ?? '');
    _namaBarangController = TextEditingController(text: widget.barang?.namaBarang ?? '');
    _stokController = TextEditingController(text: widget.barang?.stok.toString() ?? '0');
    _hargaBeliController = TextEditingController(text: widget.barang?.hargaBeli.toStringAsFixed(0) ?? '0');
    _hargaJualController = TextEditingController(text: widget.barang?.hargaJual.toStringAsFixed(0) ?? '0');
    _rakController = TextEditingController(text: widget.barang?.rak ?? '');
    
    _selectedKategori = widget.barang?.kodeKategori;
    _selectedSatuan = widget.barang?.kodeSatuan;
    
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    setState(() {
      _isLoadingDropdown = true;
    });

    try {
      final kategoriResponse = await _apiService.getKategori();
      final satuanResponse = await _apiService.getSatuan();
      
      if (mounted) {
        setState(() {
          _kategoriList = kategoriResponse.data ?? [];
          _satuanList = satuanResponse.data ?? [];
          _isLoadingDropdown = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDropdown = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error loading dropdown data: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _saveBarang() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedKategori == null || _selectedSatuan == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8),
                Text('Harap pilih kategori dan satuan'),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final barang = Barang(
          kodeBarang: _kodeBarangController.text,
          namaBarang: _namaBarangController.text,
          stok: int.tryParse(_stokController.text) ?? 0,
          hargaBeli: double.tryParse(_hargaBeliController.text) ?? 0.0,
          hargaJual: double.tryParse(_hargaJualController.text) ?? 0.0,
          kodeKategori: _selectedKategori!,
          kodeSatuan: _selectedSatuan!,
          rak: _rakController.text.isNotEmpty ? _rakController.text : null,
        );

        BarangResponse response;
        if (_isEdit) {
          response = await _apiService.updateBarang(widget.barang!.kodeBarang, barang);
        } else {
          response = await _apiService.createBarang(barang);
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

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
            widget.onSaved();
            Navigator.pop(context);
          } else {
            String errorMessage = response.message;
            if (response.errors != null) {
              // Format error messages
              final errorList = <String>[];
              response.errors!.forEach((key, value) {
                if (value is List) {
                  errorList.addAll(value.map((e) => e.toString()));
                } else {
                  errorList.add(value.toString());
                }
              });
              errorMessage += '\n${errorList.join('\n')}';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(errorMessage)),
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
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Barang' : 'Tambah Barang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
        ],
      ),
      body: _isLoadingDropdown
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data kategori dan satuan...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Kode Barang *',
                      controller: _kodeBarangController,
                      hintText: 'Masukkan kode barang',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kode barang harus diisi';
                        }
                        return null;
                      },
                      readOnly: _isEdit,
                    ),
                    CustomTextField(
                      label: 'Nama Barang *',
                      controller: _namaBarangController,
                      hintText: 'Masukkan nama barang',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama barang harus diisi';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Stok *',
                            controller: _stokController,
                            keyboardType: TextInputType.number,
                            hintText: '0',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Stok harus diisi';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Stok harus berupa angka';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'Rak',
                            controller: _rakController,
                            hintText: 'Lokasi rak (opsional)',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Harga Beli *',
                            controller: _hargaBeliController,
                            keyboardType: TextInputType.number,
                            hintText: '0',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harga beli harus diisi';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Harga beli harus berupa angka';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'Harga Jual *',
                            controller: _hargaJualController,
                            keyboardType: TextInputType.number,
                            hintText: '0',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harga jual harus diisi';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Harga jual harus berupa angka';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    // Kategori Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kategori *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: _selectedKategori,
                          items: _kategoriList.map((kategori) {
                            return DropdownMenuItem(
                              value: kategori.kodeKategori,
                              child: Text(kategori.namaKategori),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedKategori = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Pilih Kategori',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih kategori';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    // Satuan Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Satuan *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: _selectedSatuan,
                          items: _satuanList.map((satuan) {
                            return DropdownMenuItem(
                              value: satuan.kodeSatuan,
                              child: Text(satuan.namaSatuan),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSatuan = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Pilih Satuan',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih satuan';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '* Menandakan field wajib diisi',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveBarang,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isEdit ? 'UPDATE BARANG' : 'SIMPAN BARANG',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    if (_isEdit) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'BATAL',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _kodeBarangController.dispose();
    _namaBarangController.dispose();
    _stokController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _rakController.dispose();
    super.dispose();
  }
}