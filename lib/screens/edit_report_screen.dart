import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/report_model.dart';
import '../models/report_provider.dart';

class EditReportScreen extends ConsumerStatefulWidget {
  final ReportModel report;
  const EditReportScreen({super.key, required this.report});

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  final _noteController = TextEditingController();
  File? _pickedImage;
  final _formKey = GlobalKey<FormState>();

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _submitUpdate() async {
    if (!_formKey.currentState!.validate() || _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi Catatan dan Foto Hasil Pengerjaan.')),
      );
      return;
    }

    try {
      // Panggil fungsi update Mhs 4 dari Provider
      await ref.read(reportListProvider.notifier).updateReportStatus(
        reportId: widget.report.id!,
        officerNote: _noteController.text,
        completionPhotoPath: _pickedImage!.path,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil ditandai Selesai!')),
      );
      // Kembali ke Detail, lalu Detail akan kembali ke Dashboard (Mhs 3)
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyelesaikan laporan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tandai Laporan Selesai'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Laporan: ${widget.report.title}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(),

              // Input Deskripsi Pekerjaan
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Laporan Pekerjaan (Catatan Petugas)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Catatan petugas tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              Text('Foto Hasil Pengerjaan', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),

              _pickedImage != null
                  ? Image.file(_pickedImage!, height: 200, fit: BoxFit.cover)
                  : Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(child: Text('Ambil foto hasil pengerjaan')),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _takePicture,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ambil Foto Hasil'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submitUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Selesaikan dan Update Laporan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}