import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/kampus_model.dart';
import 'update_kampus.dart';

class DetailKampusPage extends StatelessWidget {
  final Kampus kampus;

  DetailKampusPage({required this.kampus});

  @override
  Widget build(BuildContext context) {
    final LatLng lokasi = LatLng(kampus.latitude, kampus.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          kampus.nama,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UpdateKampusPage(kampus: kampus),
                ),
              );

              if (result == true) {
                Navigator.pop(context); // kembali ke list dan refresh
              }
            },
          )
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alamat:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(kampus.alamatLengkap, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Text('Telepon:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(kampus.noTelepon, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Text('Kategori:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(kampus.kategori, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 12),
                  Text('Jurusan:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(kampus.jurusan, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Lokasi Kampus',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: lokasi,
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('lokasi_kampus'),
                    position: lokasi,
                    infoWindow: InfoWindow(title: kampus.nama),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
