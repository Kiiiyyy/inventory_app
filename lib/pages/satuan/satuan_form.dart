import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/satuan_model.dart';
import '../../widgets/custom_textfield.dart';

class SatuanForm extends StatefulWidget {
  final Satuan? satuan;
  final Function() onSaved;

  const SatuanForm({
    Key? key,
    this.satuan,
    required this.onSaved,
  }) : super(key: key);

  @override
  _SatuanFormState createState() => _SatuanFormState();
}

class _SatuanFormState extends State<SatuanForm> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  
  late TextEditingController _kodeSatuanController;
  late TextEditingController _namaSatuanController;
  
  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.satuan != null;
    
    _kodeSatuanController = TextEditingController(text: widget.satuan?.kodeSatuan ?? '');
    _namaSatuanController = TextEditingController(text: widget.satuan?.namaSatuan ?? '');
  }

  Future<void> _saveSatuan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final satuan = Satuan(
          kodeSatuan: _kodeSatuanController.text,
          namaSatuan: _namaSatuanController.text,
        );

        SatuanResponse response;
        if (_isEdit) {
          response = await _apiService.updateSatuan(widget.satuan!.kodeSatuan, satuan);
        } else {
          response = await _apiService.createSatuan(satuan);
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
        title: Text(_isEdit ? 'Edit Satuan' : 'Tambah Satuan'),
        backgroundColor: Colors.orange,
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
                label: 'Kode Satuan *',
                controller: _kodeSatuanController,
                hintText: 'Masukkan kode satuan',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode satuan harus diisi';
                  }
                  return null;
                },
                readOnly: _isEdit, // Tidak bisa edit kode satuan jika mode edit
              ),
              CustomTextField(
                label: 'Nama Satuan *',
                controller: _namaSatuanController,
                hintText: 'Masukkan nama satuan',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama satuan harus diisi';
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
                  onPressed: _isLoading ? null : _saveSatuan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
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
                          _isEdit ? 'UPDATE SATUAN' : 'SIMPAN SATUAN',
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
    _kodeSatuanController.dispose();
    _namaSatuanController.dispose();
    super.dispose();
  }
}