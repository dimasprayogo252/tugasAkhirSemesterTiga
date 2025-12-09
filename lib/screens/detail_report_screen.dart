import 'dart:io';
import 'package:flutter/material.dart';
import '../models/report_model.dart';

class ReportDetailScreen extends StatelessWidget {
  final ReportModel report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              report.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const Divider(height: 32),

            Text('Bukti Visual:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Center(
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: report.imagePath.isNotEmpty
                    ? Image.file(
                  File(report.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text('Gagal memuat gambar'),
                  ),
                )
                    : const Center(child: Text('Tidak ada gambar tersedia')),
              ),
            ),
            const Divider(height: 32),

            Text('Deskripsi:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              report.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 32),

            Text('Lokasi GPS:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latitude: ${report.latitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Longitude: ${report.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}