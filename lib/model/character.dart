class Character {
  final int id;
  final String name;
  final Status status;
  final String image;
  final ApiLocation origin;
  final ApiLocation location;
  final List<int> episodes;

  Character(
      {required this.id,
      required this.name,
      required this.status,
      required this.image,
      required this.origin,
      required this.location,
      required this.episodes});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
        id: json['id'],
        name: json['name'],
        status: getStatusFromString(json['status']),
        image: json['image'],
        origin: ApiLocation.fromJson(json['origin']),
        location: ApiLocation.fromJson(json['location']),
        episodes: (json['episode'] as List<dynamic>).map((e) {
          var match = RegExp(r'\d+$').firstMatch(e);
          return int.parse(match?.group(0) ?? '0');
        }).toList());
  }

  static List<Character> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Character.fromJson(json)).toList();
  }
}

enum Status { all, alive, dead, unknown }

Status getStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case "all":
      return Status.all;
    case "dead":
      return Status.dead;
    case "alive":
      return Status.alive;
    case "unknown":
      return Status.unknown;
    default:
      throw ArgumentError("Unsupported status string: $status");
  }
}

class ApiLocation {
  final String name;

  ApiLocation({required this.name});

  factory ApiLocation.fromJson(Map<String, dynamic> json) {
    return ApiLocation(name: json['name']);
  }
}
