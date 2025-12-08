class ReportModel {
  int? id;
  String title;
  String description;
  String date;

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) => ReportModel(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    date: map['date'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date,
  };
}
