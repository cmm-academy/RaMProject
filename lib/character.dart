class Character {
  final int id;
  final String name;
  final String status;
  final String image;
  final ApiLocation origin;
  final ApiLocation location;

  Character(
      {required this.id,
      required this.name,
      required this.status,
      required this.image,
      required this.origin,
      required this.location});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
        id: json['id'],
        name: json['name'],
        status: json['status'],
        image: json['image'],
        origin: ApiLocation.fromJson(json['origin']),
        location: ApiLocation.fromJson(json['location']));
  }

  static List<Character> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Character.fromJson(json)).toList();
  }
}

class ApiLocation {
  final String name;

  ApiLocation({required this.name});

  factory ApiLocation.fromJson(Map<String, dynamic> json) {
    return ApiLocation(name: json['name']);
  }
}
