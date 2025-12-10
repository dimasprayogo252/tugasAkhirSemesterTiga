import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../models/report_provider.dart';
import 'edit_report_screen.dart';

class ReportDetailScreen extends ConsumerWidget {
  final int reportId;

  const ReportDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);
    final report = reports.firstWhere((r) => r.id == reportId);

    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildStatusBadge(report.status),
            const Divider(height: 16),

            Text('Bukti Visual Laporan:', style: Theme.of(context).textTheme.titleMedium),
            Image.file(File(report.imagePath), height: 250, width: double.infinity, fit: BoxFit.cover),
            const Divider(height: 32),

            Text('Deskripsi:', style: Theme.of(context).textTheme.titleMedium),
            Text(report.description, style: Theme.of(context).textTheme.bodyLarge),

            Text('Lokasi GPS:', style: Theme.of(context).textTheme.titleMedium),
            Text('Lat: ${report.latitude}, Long: ${report.longitude}'),
            const Divider(height: 32),

            if (report.status == 'Selesai') ...[
              Text('TINDAKAN PETUGAS:', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.green)),
              Text('Catatan: ${report.officerNote}', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              Text('Foto Hasil Pengerjaan:', style: Theme.of(context).textTheme.titleMedium),
              Image.file(File(report.completionPhotoPath!), height: 250, width: double.infinity, fit: BoxFit.cover),
              const Divider(height: 32),
            ],

            _buildActionButtons(context, report, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = status == 'Selesai' ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButtons(BuildContext context, ReportModel report, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (report.status == 'Pending')
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditReportScreen(report: report),
              ));
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Tandai Selesai'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),

        // 2. Tombol Hapus
        ElevatedButton.icon(
          onPressed: () => _showDeleteConfirmation(context, report, ref),
          icon: const Icon(Icons.delete),
          label: const Text('Hapus Laporan'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, ReportModel report, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus laporan ini secara permanen?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref.read(reportListProvider.notifier).deleteReport(report.id!);
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}