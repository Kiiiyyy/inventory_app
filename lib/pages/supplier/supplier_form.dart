import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/supplier_model.dart';
import '../../widgets/custom_textfield.dart';

class SupplierForm extends StatefulWidget {
  final Supplier? supplier;
  final Function() onSaved;

  const SupplierForm({
    Key? key,
    this.supplier,
    required this.onSaved,
  }) : super(key: key);

  @override
  _SupplierFormState createState() => _SupplierFormState();
}

class _SupplierFormState extends State<SupplierForm> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  
  late TextEditingController _kodeSuplierController;
  late TextEditingController _namaSuplierController;
  late TextEditingController _alamatController;
  late TextEditingController _phoneController;
  late TextEditingController _namaPtController;
  late TextEditingController _faxController;
  
  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.supplier != null;
    
    _kodeSuplierController = TextEditingController(text: widget.supplier?.kodeSuplier ?? '');
    _namaSuplierController = TextEditingController(text: widget.supplier?.namaSuplier ?? '');
    _alamatController = TextEditingController(text: widget.supplier?.alamat ?? '');
    _phoneController = TextEditingController(text: widget.supplier?.phone ?? '');
    _namaPtController = TextEditingController(text: widget.supplier?.namaPt ?? '');
    _faxController = TextEditingController(text: widget.supplier?.fax ?? '');
  }

  Future<void> _saveSupplier() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final supplier = Supplier(
          kodeSuplier: _kodeSuplierController.text,
          namaSuplier: _namaSuplierController.text,
          alamat: _alamatController.text,
          phone: _phoneController.text,
          namaPt: _namaPtController.text.isNotEmpty ? _namaPtController.text : null,
          fax: _faxController.text.isNotEmpty ? _faxController.text : null,
        );

        SupplierResponse response;
        if (_isEdit) {
          response = await _apiService.updateSupplier(widget.supplier!.kodeSuplier, supplier);
        } else {
          response = await _apiService.createSupplier(supplier);
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
        title: Text(_isEdit ? 'Edit Supplier' : 'Tambah Supplier'),
        backgroundColor: Colors.purple,
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
                label: 'Kode Supplier *',
                controller: _kodeSuplierController,
                hintText: 'Masukkan kode supplier',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode supplier harus diisi';
                  }
                  return null;
                },
                readOnly: _isEdit, // Tidak bisa edit kode supplier jika mode edit
              ),
              CustomTextField(
                label: 'Nama Supplier *',
                controller: _namaSuplierController,
                hintText: 'Masukkan nama supplier',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama supplier harus diisi';
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: 'Nama PT',
                controller: _namaPtController,
                hintText: 'Masukkan nama perusahaan (opsional)',
              ),
              CustomTextField(
                label: 'Alamat *',
                controller: _alamatController,
                hintText: 'Masukkan alamat supplier',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat harus diisi';
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: 'Telepon *',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                hintText: 'Masukkan nomor telepon',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon harus diisi';
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: 'Fax',
                controller: _faxController,
                keyboardType: TextInputType.phone,
                hintText: 'Masukkan nomor fax (opsional)',
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
                  onPressed: _isLoading ? null : _saveSupplier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
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
                          _isEdit ? 'UPDATE SUPPLIER' : 'SIMPAN SUPPLIER',
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
    _kodeSuplierController.dispose();
    _namaSuplierController.dispose();
    _alamatController.dispose();
    _phoneController.dispose();
    _namaPtController.dispose();
    _faxController.dispose();
    super.dispose();
  }
}