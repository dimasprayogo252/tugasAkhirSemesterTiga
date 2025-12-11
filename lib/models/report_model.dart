
class ReportModel {
  int? id;
  String title;
  String description;
  String imagePath;
  double latitude;
  double longitude;
  String status;
  DateTime date;
  String? officerNote;
  String? completionPhotoPath;
  bool? isCompleted;

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.date,
    this.officerNote,
    this.completionPhotoPath,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) => ReportModel(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    imagePath: map['imagePath'],
    latitude: map['latitude'],
    longitude: map['longitude'],
    status: map['status'] ?? 'Pending',
    date: DateTime.parse(map['date']),
    officerNote: map['officerNote'],
    completionPhotoPath: map['completionPhotoPath'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'imagePath': imagePath,
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
    'date': date.toIso8601String(),
    'officerNote': officerNote,
    'completionPhotoPath': completionPhotoPath,
  };


  ReportModel copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
    double? latitude,
    double? longitude,
    String? status,
    DateTime? date,
    String? officerNote,
    String? completionPhotoPath,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      date: date ?? this.date,
      officerNote: officerNote ?? this.officerNote,
      completionPhotoPath: completionPhotoPath ?? this.completionPhotoPath,
    );
  }
}