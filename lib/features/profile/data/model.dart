// models/user_profile.dart

class UserProfile {
  final String id;
  final String email;
  String name;
  String profession;
  DateTime birthDate;
  String? avatarUrl;

  /// Новое поле локации
  final LocationData? location;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.profession,
    required this.birthDate,
    this.avatarUrl,
    this.location,
  });
}

class LocationData {
  final double latitude;
  final double longitude;
  final String address;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
