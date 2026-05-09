# SpendWise - Personal Finance Manager

SpendWise adalah aplikasi manajemen ke uangan pribadi berbasis Flutter yang dirancang untuk membantu pengguna mencatat riwayat transaksi harian secara sederhana, cepat, dan elegan.

---

## 🗺️ Blueprint (Rencana Kerja Aplikasi)
Blueprint ini berfungsi sebagai acuan pengembangan dari tahap awal hingga aplikasi siap rilis.

* **Nama Aplikasi:** SpendWise
* **Tema:** Personal Finance Manager (Manajemen Keuangan Pribadi)
* **Tujuan:** Membantu pengguna mencatat arus kas (pemasukan & pengeluaran) secara mandiri.

### Tahapan Pengembangan:

**Fase I: Inisialisasi**
* **Kegiatan Utama:** Setup Project & GIT.
* **Detail Teknis:** `flutter create`, inisialisasi repo GitHub, dan Koneksi remote.

**Fase II: Desai UI**
* **Kegiatan Utama:** Layouting & Styling.
* **Detail Teknis:** Implementasi `LinearGradient` biru, Custom Cards, dan `FloatingActionButton`.

**Fase III: Logika Data**
* **Kegiatan Utama:** Manajemen State & Model.
* **Detail Teknis:** Pembuatan class `Transaksi` dan pengelolaan list menggunakan `StatefulWidget`.

**Fase IV: Persistence**
* **Kegiatan Utama:** Penimpanan Lokal.
* **Detail Teknis:** Integrasi `shared_preferences` agar data tidak hilang saat aplikasi ditutup.

**Fase V: Pengujian**
* **Kegiatan Utama:** Unit & Widget Testing.
* **Detail Teknis:** Menjalankan `widget_test.dart` untuk memastikan komponen utama muncul.

**Fase VI: Deployment**
* **Kegiatan Utama:** Persiapan Rilis.
* **Detail Teknis:** Konfigurasi `AndroidManifest.xml`, pembuatan icon aplikasi, dan proses pendaftaran ke store.

---

## 📝 Fitur Utama
* **Dashboard Saldo:** Menampilkan total saldo, total pemasukan, dan total pengeluaran secara real-time.
* **Pencatatan Transaksi:**Menambah catatan pemasukan atau pengeluaran dengan keterangan yanga jelas.
* **Penyimpanan Lokal:** Menggunakan `shared_preferences` sehingga data tersimpan aman di perangkat pengguna.
* **Hapus Transaksi:** Fitur *swipe-to-delete* (geser untuk menghapus) pada daftar riwayat.
* **UI Elegan:** Desain modern dengan skema warna biru dan tampilan kartu yang bersih.

## ⚙️ Cara Kerja Aplikasi
1. **Inisialisasi:** Saat aplikasi dibuka, sistem memuat data transaksi lama dari penyimpanan lokal (JSON format).
2. **Tambah Data:** Pengguna menekan tombol "+ Tambah", mengisi keterangan dan nominal, lalu memilih jenis transaksi.
3. **Kalkulasi Otomatis:** Sistem secara otomatis menghitung ulang saldo akhir setiap kali ada perubahan data.
4. **Keamanan Data:** Setiap transaksi baru akan langsung disinkronkan ke memori internal HP dalam bentuk string JSON.

## 🛠️ Teknologi yang Digunakan
* **Framework:** Flutter
* **Bahasa:** Dart
* **Penyimpanan:** Shared Preferences
* **Version Control:** Git & GitHub

