import 'package:flutter/material.dart';
import '../model/kampus_model.dart';
import '../services/api_service.dart';

class UpdateKampusPage extends StatefulWidget {
  final Kampus kampus;

  UpdateKampusPage({required this.kampus});

  @override
  _UpdateKampusPageState createState() => _UpdateKampusPageState();
}

class _UpdateKampusPageState extends State<UpdateKampusPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _teleponController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _jurusanController;
  late String _kategori;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.kampus.nama);
    _alamatController = TextEditingController(text: widget.kampus.alamatLengkap);
    _teleponController = TextEditingController(text: widget.kampus.noTelepon);
    _latitudeController = TextEditingController(text: widget.kampus.latitude.toString());
    _longitudeController = TextEditingController(text: widget.kampus.longitude.toString());
    _jurusanController = TextEditingController(text: widget.kampus.jurusan);
    _kategori = widget.kampus.kategori;
  }

  void _submitUpdate() async {
    if (_formKey.currentState!.validate()) {
      Kampus updatedKampus = Kampus(
        no: widget.kampus.no,
        nama: _namaController.text,
        alamatLengkap: _alamatController.text,
        noTelepon: _teleponController.text,
        kategori: _kategori,
        latitude: double.tryParse(_latitudeController.text) ?? 0.0,
        longitude: double.tryParse(_longitudeController.text) ?? 0.0,
        jurusan: _jurusanController.text,
      );

      try {
        await ApiService().updateKampus(updatedKampus);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Gagal mengupdate data')),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _jurusanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Kampus'),
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
                    items: ['swasta', 'negeri']
                        .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                        .toList(),
                    onChanged: (val) => setState(() => _kategori = val!),
                    decoration: InputDecoration(labelText: 'Kategori'),

                  ),
                  SizedBox(height: 24),
                  _buildTextField(_latitudeController, 'Latitude', isNumber: true),
                  _buildTextField(_longitudeController, 'Longitude', isNumber: true),
                  _buildTextField(_jurusanController, 'Jurusan'),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _submitUpdate,
                    icon: Icon(Icons.update),
                    label: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
