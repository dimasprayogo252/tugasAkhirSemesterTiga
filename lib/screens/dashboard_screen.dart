import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/report_provider.dart';
import '/models/report_model.dart';
import 'detail_report_screen.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);

    // Cek Status Loading/Data Kosong (Opsional, tapi disarankan)
    if (reports.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daftar Laporan (The Monitor)')),
        body: const Center(child: Text('Belum ada laporan. Coba buat laporan baru.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard & Laporan'),
        backgroundColor: Colors.indigo,
        elevation: 1,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                'Ringkasan Statistik Laporan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),


            SummaryCardWidget(), // HAPUS 'const' di sini
            const Divider(height: 30, thickness: 1),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                'Daftar Laporan (Read List)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Menggunakan ReportListView (ConsumerWidget) (Tugas 3.2)
            ReportListView(), // HAPUS 'const' di sini (KRITIS)
          ],
        ),
      ),
    );
  }
}

// 2. SummaryCardWidget (Implementasi Tugas 3.3: Header Ringkasan)

class SummaryCardWidget extends ConsumerWidget {
  const SummaryCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ReportModel> reports = ref.watch(reportListProvider);
    final int totalReports = reports.length;
    // Asumsi properti isCompleted ada di ReportModel
    final int completedReports = reports.where((r) => r.isCompleted == true).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Laporan Keseluruhan (X)',
                style: TextStyle(fontSize: 16, color: Colors.indigo),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalReports',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Laporan Selesai (Y*):', style: TextStyle(fontSize: 16)),
                  Text(
                    '$completedReports',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. ReportListView
class ReportListView extends ConsumerWidget {
  const ReportListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Menggunakan ref.watch untuk pembaruan real-time (Tugas 3.2)
    final List<ReportModel> reports = ref.watch(reportListProvider);

    if (reports.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Tidak ada laporan yang tersedia.'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];

        // Logika untuk Tugas
        final bool isCompleted = report.isCompleted ?? false;
        final Color statusColor = isCompleted ? Colors.green : Colors.red;
        final String statusText = isCompleted ? 'Selesai' : 'Pending';

        return ListTile(
          // Tambahkan Key unik (Opsional, tapi disarankan untuk List dinamis)
          key: ValueKey(report.id),
          leading: Container(
            width: 6,
            height: double.infinity,
            color: statusColor,
            margin: const EdgeInsets.only(right: 8),
          ),

          title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(report.description),


          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Text(report.id != null ? 'ID: ${report.id}' : 'ID: N/A', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),


          onTap: () {
            if (report.id == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Laporan tidak lengkap (ID hilang).')),
              );
              return;
            }


            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportDetailScreen(
                  reportId: report.id!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}