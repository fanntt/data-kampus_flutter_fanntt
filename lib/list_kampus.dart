import 'package:flutter/material.dart';
import '../model/kampus_model.dart';
import '../services/api_service.dart';
import 'tambah_kampus.dart';
import 'detail_kampus.dart';

class ListKampusPage extends StatefulWidget {
  @override
  _ListKampusPageState createState() => _ListKampusPageState();
}

class _ListKampusPageState extends State<ListKampusPage> {
  List<Kampus> kampusList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() => isLoading = true);
    final data = await ApiService().getAllKampus();
    setState(() {
      kampusList = data;
      isLoading = false;
    });
  }

  void konfirmasiHapusKampus(BuildContext context, int no, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus kampus "$nama"?'),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'Ya, Hapus',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog
              await ApiService().deleteKampus(no);
              fetchData(); // Refresh data
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Kampus'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : kampusList.isEmpty
          ? Center(child: Text("Belum ada data kampus."))
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: kampusList.length,
        itemBuilder: (context, index) {
          final kampus = kampusList[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                kampus.nama,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text("Kategori: ${kampus.kategori}"),
                  Text("Jurusan: ${kampus.jurusan}"),
                ],
              ),
              leading: CircleAvatar(
                child: Icon(Icons.school),
                backgroundColor: Colors.blue.shade100,
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  konfirmasiHapusKampus(context, kampus.no, kampus.nama);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailKampusPage(kampus: kampus),
                  ),
                ).then((_) => fetchData());
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahKampusPage()),
          ).then((_) => fetchData());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
