import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/report_provider.dart';
import '/models/report_model.dart';
import 'detail_report_screen.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Ringkasan Statistik',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildStatCards(),

            const Divider(height: 30, thickness: 1),

            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                'Laporan Terbaru (Read List)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // Menggunakan ReportListView (ConsumerWidget)
            const ReportListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCard(title: 'Penjualan', value: 'Rp 10 Juta', icon: Icons.attach_money, color: Colors.green),
          _StatCard(title: 'Pengguna', value: '1.200', icon: Icons.people, color: Colors.blue),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(title, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// ReportListView
// =========================================================

class ReportListView extends ConsumerWidget {
  const ReportListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch reportListProvider
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
      // Penting: shrinkWrap dan NeverScrollableScrollPhysics diperlukan karena berada di dalam SingleChildScrollView
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return ListTile(
          leading: const Icon(Icons.file_present, color: Colors.indigo),
          title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(report.description),
          // Menampilkan ID (asumsi ID adalah int?)
          trailing: Text(report.id != null ? 'ID: ${report.id}' : 'ID: N/A', style: const TextStyle(fontSize: 12, color: Colors.grey)),

          onTap: () {
            // ✅ KETAHANAN: Periksa null sebelum menggunakan ID
            if (report.id == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Laporan tidak lengkap (ID hilang).')),
              );
              return;
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportDetailScreen(
                  reportId: report.id!, // ID dipastikan ada di sini
                ),
              ),
            );
          },
        );
      },
    );
  }
}