class ReportModel {
  int? id;
  String title;
  String description;
  String imagePath;
  double latitude;
  double longitude;
  DateTime date;

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.date,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) => ReportModel(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    imagePath: map['image'],
    latitude: map['latitude'],
    longitude: map['longitude'],
    date: map['date'],
  );



  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'image': imagePath,
    'latitude': latitude,
    'longitude': longitude,
    'date': date,
  };
}
