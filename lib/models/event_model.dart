class Event {
  int? id;
  String title;
  String description;
  DateTime date;
  String imagePath;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      imagePath: map['imagePath'],
    );
  }
  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    String? imagePath,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
