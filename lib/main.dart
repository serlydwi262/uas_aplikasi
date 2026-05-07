import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpendWise',
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}

class Transaksi {
  final String id;
  final String judul;
  final double jumlah;
  final DateTime tanggal;
  final bool isPemasukan;

  Transaksi({
    required this.id,
    required this.judul,
    required this.jumlah,
    required this.tanggal,
    required this.isPemasukan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'jumlah': jumlah,
      'tanggal': tanggal.toIso8601String(),
      'isPemasukan': isPemasukan,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      judul: map['judul'],
      jumlah: map['jumlah'],
      tanggal: DateTime.parse(map['tanggal']),
      isPemasukan: map['isPemasukan'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Transaksi> _userTransaksi = [];
  final _judulController = TextEditingController();
  final _jumlahController = TextEditingController();
  bool _statusPemasukan = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataJson = prefs.getString('transaksi_list');

    if (dataJson != null) {
      final List<dynamic> decodedData = json.decode(dataJson);
      setState(() {
        _userTransaksi = decodedData.map((item) => Transaksi.fromMap(item)).toList();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _userTransaksi.map((item) => item.toMap()).toList(),
    );
    await prefs.setString('transaksi_list', encodedData);
  }

  double get _totalPemasukan => _userTransaksi.where((t) => t.isPemasukan).fold(0, (a, b) => a + b.jumlah);
  double get _totalPengeluaran => _userTransaksi.where((t) => !t.isPemasukan).fold(0, (a, b) => a + b.jumlah);
  double get _totalSaldo => _totalPemasukan - _totalPengeluaran;

  void _tambahDataBaru() {
    final judul = _judulController.text;
    final nominal = double.tryParse(_jumlahController.text) ?? 0;

    if (judul.isEmpty || nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data tidak valid! Isi semua kolom.")),
      );
      return;
    }


    FocusScope.of(context).unfocus();

    setState(() {
      _userTransaksi.insert(0, Transaksi(
        id: DateTime.now().toString(),
        judul: judul,
        jumlah: nominal,
        tanggal: DateTime.now(),
        isPemasukan: _statusPemasukan,
      ));
    });

    _saveData();
    _judulController.clear();
    _jumlahController.clear();
    Navigator.of(context).pop();
  }

  void _hapusTransaksi(String id) {
    setState(() {
      _userTransaksi.removeWhere((t) => t.id == id);
    });
    _saveData();
  }

  void _bukaModalInput(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Tambah Catatan Baru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(controller: _judulController, decoration: const InputDecoration(labelText: 'Keterangan')),
                TextField(controller: _jumlahController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Nominal (Rp)')),
                const SizedBox(height: 15),
                ToggleButtons(
                  isSelected: [!_statusPemasukan, _statusPemasukan],
                  onPressed: (index) => setModalState(() => _statusPemasukan = index == 1),
                  borderRadius: BorderRadius.circular(10),
                  
                  selectedColor: Colors.white,
                  fillColor:  Colors.blue,
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Pengeluaran")),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Pemasukan")),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _tambahDataBaru,
                  
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                  child: const Text ("Simpan Transaksi"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Spendwise", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),

              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.blue, Colors.indigo],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5)
                )
              ],
            ),
            child: Column(
              children: [
                const Text("Total Saldo", style: TextStyle(color: Colors.white70)),
                Text(
                  "Rp ${NumberFormat('#,###', 'id_ID').format(_totalSaldo)}",
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)
                ),
                const Divider(color: Colors.white24, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem("Masuk", _totalPemasukan, Icons.arrow_downward, Colors.white),
                    _buildStatItem("Keluar", _totalPengeluaran, Icons.arrow_upward, Colors.white),
                  ],
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Riwayat Transaksi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ),
          ),
          Expanded(
            child: _userTransaksi.isEmpty
                ? const Center(child: Text("Belum ada data."))
                : ListView.builder(
                  itemCount: _userTransaksi.length,
                  itemBuilder: (ctx, i)  {
                    final t = _userTransaksi[i];
                    return Dismissible(
                      key: Key(t.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (dir) => _hapusTransaksi(t.id),
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            
                            backgroundColor: t.isPemasukan ? Colors.blue[50] : Colors.red[50],
                            child: Icon(
                              t.isPemasukan ? Icons.account_balance_wallet : Icons.shopping_bag,
                              color: t.isPemasukan ? Colors.blue : Colors.red,
                            ),
                          ),
                          title: Text(t.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(DateFormat('dd MMM yyyy').format(t.tanggal)),
                          trailing: Text(
                            "Rp ${NumberFormat('#,###', 'id_ID').format(t.jumlah)}",
                            style: TextStyle(
                              color: t.isPemasukan ? Colors.blue : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaModalInput(context),
        label: const Text("Tambah"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStatItem(String label, double val, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 10, color: color.withOpacity(0.7))),
          Text(
            "Rp ${NumberFormat('#,###', 'id_ID').format(val)}",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)
          ),
        ]),
      ],
    );
  }
}