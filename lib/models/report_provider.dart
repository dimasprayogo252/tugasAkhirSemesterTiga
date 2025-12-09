// lib/providers/report_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'report_model.dart';
import '../helper/db_helper.dart';

final reportListProvider = StateNotifierProvider<ReportNotifier, List<ReportModel>>((ref) {
  return ReportNotifier();
});

class ReportNotifier extends StateNotifier<List<ReportModel>> {
  ReportNotifier() : super([]) {
    loadReports();
  }

  Future<void> loadReports() async {
    state = await DBHelper.instance.getAllReports();
  }

  Future<void> addReport(ReportModel report) async {
    final id = await DBHelper.instance.insertReport(report);
    final newReport = report.copyWith(id: id);
    state = [newReport, ...state];
  }

  Future<void> deleteReport(int reportId) async {
    await DBHelper.instance.deleteReport(reportId);
    state = state.where((r) => r.id != reportId).toList();
  }

  Future<void> updateReportStatus({
    required int reportId,
    required String officerNote,
    required String completionPhotoPath,
  }) async {
    final oldReport = state.firstWhere((r) => r.id == reportId);

    final updatedReport = oldReport.copyWith(
      status: 'Selesai',
      officerNote: officerNote,
      completionPhotoPath: completionPhotoPath,
    );

    await DBHelper.instance.updateReport(updatedReport);

    state = state.map((r) => r.id == reportId ? updatedReport : r).toList();
  }
}