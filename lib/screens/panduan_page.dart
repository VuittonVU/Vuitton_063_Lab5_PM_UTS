import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/back_button.dart';

class PanduanPage extends StatelessWidget {
  const PanduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // UI dinamis
    final screenWidth = MediaQuery.of(context).size.width;

    final titleFont = screenWidth * 0.06;
    final bodyFont = screenWidth * 0.04;
    final paddingAll = screenWidth * 0.06;
    final containerPadding = screenWidth * 0.05;
    final borderRadius = screenWidth * 0.03;

    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300),
        elevation: 0,
        leading: BackButtonWidget(
          onPressed: () {
            context.go('/home');
          },
        ),
        centerTitle: true,
        title: Text(
          'Panduan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: titleFont,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(paddingAll),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container panduan
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(containerPadding),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD382),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(color: Colors.black, width: 1.2),
                ),
                child: Text(
                  '''
Panduan Cara Bermain

1. Masukkan nama Anda di halaman login.
2. Tekan tombol Main untuk memulai permainan.
3. Anda akan diberikan pertanyaan dengan jawaban pilihan berganda.
4. Setiap jawaban benar akan memberikan sejumlah uang — semakin jauh kamu menjawab, semakin besar hadiahnya.
5. Anda diberikan dua fitur bantuan:
   - 50:50 → Menghapus dua pilihan jawaban yang salah.
   - Refresh → Mengganti pertanyaan dengan yang baru.
   (Keduanya hanya bisa digunakan satu kali per permainan)
6. Jika waktu habis atau jawaban salah, permainan berakhir.
7. Lihat total uang yang Anda kumpulkan di halaman akhir!

Selamat bermain dan jadilah Triliuner!!
''',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: bodyFont,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
