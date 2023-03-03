class Job {
  Job({required this.id, required this.name, required this.ratePerHour});

  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic>? data, String documentID) {
    if (data == null) {
      throw ArgumentError('map must not be null');
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(id: documentID, name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ratePerHour': ratePerHour};
  }
}
