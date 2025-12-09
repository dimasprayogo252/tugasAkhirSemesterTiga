import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_report_screen.dart';
import '../providers/session_pro.dart';
import 'detail_report_screen.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Laporan (The Reporter)'),
        backgroundColor: Colors.blueAccent,
      ),
      body: reports.isEmpty?
      const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada laporan yang tercatat.', style: TextStyle(fontSize: 18)),
            Text('Tekan tombol + untuk membuat laporan baru.'),
          ],
        ),
      )
          : ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];


          return Dismissible(
            key: UniqueKey(),

            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),

            direction: DismissDirection.endToStart,



            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: const Icon(Icons.description, color: Colors.blueAccent),
                title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('Lat: ${report.latitude.toStringAsFixed(4)}, Long: ${report.longitude.toStringAsFixed(4)}'),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportDetailScreen(report: report),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddReportScreen(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}