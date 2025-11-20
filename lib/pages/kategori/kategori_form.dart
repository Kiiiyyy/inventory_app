import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/kategori_model.dart';
import '../../widgets/custom_textfield.dart';

class KategoriForm extends StatefulWidget {
  final Kategori? kategori;
  final Function() onSaved;

  const KategoriForm({
    Key? key,
    this.kategori,
    required this.onSaved,
  }) : super(key: key);

  @override
  _KategoriFormState createState() => _KategoriFormState();
}

class _KategoriFormState extends State<KategoriForm> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  
  late TextEditingController _kodeKategoriController;
  late TextEditingController _namaKategoriController;
  
  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.kategori != null;
    
    _kodeKategoriController = TextEditingController(text: widget.kategori?.kodeKategori ?? '');
    _namaKategoriController = TextEditingController(text: widget.kategori?.namaKategori ?? '');
  }

  Future<void> _saveKategori() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final kategori = Kategori(
          kodeKategori: _kodeKategoriController.text,
          namaKategori: _namaKategoriController.text,
        );

        KategoriResponse response;
        if (_isEdit) {
          response = await _apiService.updateKategori(widget.kategori!.kodeKategori, kategori);
        } else {
          response = await _apiService.createKategori(kategori);
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (response.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message),
                backgroundColor: Colors.green,
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
                content: Text(errorMessage),
                backgroundColor: Colors.red,
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
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
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
        title: Text(_isEdit ? 'Edit Kategori' : 'Tambah Kategori'),
        backgroundColor: Colors.green,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'Kode Kategori *',
                controller: _kodeKategoriController,
                hintText: 'Masukkan kode kategori',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode kategori harus diisi';
                  }
                  return null;
                },
                readOnly: _isEdit, // Tidak bisa edit kode kategori jika mode edit
              ),
              CustomTextField(
                label: 'Nama Kategori *',
                controller: _namaKategoriController,
                hintText: 'Masukkan nama kategori',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kategori harus diisi';
                  }
                  return null;
                },
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
                  onPressed: _isLoading ? null : _saveKategori,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
                          _isEdit ? 'UPDATE KATEGORI' : 'SIMPAN KATEGORI',
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
    _kodeKategoriController.dispose();
    _namaKategoriController.dispose();
    super.dispose();
  }
}