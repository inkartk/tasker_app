class SubTask {
  final int? id;
  final String title;
  final bool isDone;

  SubTask({
    this.id,
    required this.title,
    this.isDone = false,
  });

  SubTask copyWith({
    int? id,
    String? title,
    bool? isDone,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  factory SubTask.fromJson(Map<String, dynamic> json) => SubTask(
        id: json['id'] as int?,
        title: json['title'] as String,
        isDone: json['isDone'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
      };
}
