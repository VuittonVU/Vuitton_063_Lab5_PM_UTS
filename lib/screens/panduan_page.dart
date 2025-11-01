import 'package:flutter/material.dart';
import 'home_page.dart';

class PanduanPage extends StatelessWidget {
  const PanduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB300),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB300),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        title: const Text(
          'Panduan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container untuk teks panduan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD382), // krem muda
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: const Text(
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
                    fontSize: 16,
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
