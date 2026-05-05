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

  Map<String, dynamic> topMap() {
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
}