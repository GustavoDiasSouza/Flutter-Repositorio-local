class Album {
  final int value;
  final int id;
  final String dateTime;
  final Object contact;

  const Album({
    required this.value,
    required this.id,
    required this.dateTime,
    required this.contact,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      value: json['value'],
      id: json['id'],
      contact: json['contact'],
      dateTime: json['dateTime'],
    );
  }
}