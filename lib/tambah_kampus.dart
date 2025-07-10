import 'package:flutter/material.dart';
import '../model/kampus_model.dart';
import '../services/api_service.dart';

class TambahKampusPage extends StatefulWidget {
  @override
  _TambahKampusPageState createState() => _TambahKampusPageState();
}

class _TambahKampusPageState extends State<TambahKampusPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();

  String _kategori = 'Swasta';

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      Kampus kampusBaru = Kampus(
        no: 0, // di-generate oleh server
        nama: _namaController.text,
        alamatLengkap: _alamatController.text,
        noTelepon: _teleponController.text,
        kategori: _kategori,
        latitude: double.tryParse(_latitudeController.text) ?? 0.0,
        longitude: double.tryParse(_longitudeController.text) ?? 0.0,
        jurusan: _jurusanController.text,
      );

      try {
        await ApiService().tambahKampus(kampusBaru);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Gagal menambahkan data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Kampus'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_namaController, 'Nama Kampus', required: true),
                  _buildTextField(_alamatController, 'Alamat Lengkap'),
                  _buildTextField(_teleponController, 'No Telepon'),
                  DropdownButtonFormField<String>(
                    value: _kategori,
                    items: ['Swasta', 'Negeri']
                        .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                        .toList(),
                    onChanged: (val) => setState(() => _kategori = val!),
                    decoration: InputDecoration(labelText: 'Kategori'),
                  ),
                  SizedBox(height: 24),
                  _buildTextField(_latitudeController, 'Latitude',
                      isNumber: true),
                  _buildTextField(_longitudeController, 'Longitude',
                      isNumber: true),
                  _buildTextField(_jurusanController, 'Jurusan'),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _submitData,
                    icon: Icon(Icons.save),
                    label: Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool required = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: required
            ? (value) => value!.isEmpty ? '$label tidak boleh kosong' : null
            : null,
      ),
    );
  }
}
