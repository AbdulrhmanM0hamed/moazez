class ProfileResponse {
  final ProfileData data;

  ProfileResponse({required this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final UserProfile user;

  ProfileData({required this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: UserProfile.fromJson(json['user']),
    );
  }
}

class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String userType;
  final bool isActive;
  final String? gender;
  final String? birthdate;
  final Area? area;
  final City? city;
  final ActiveSubscription? activeSubscription;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.userType,
    required this.isActive,
    this.gender,
    this.birthdate,
    this.area,
    this.city,
    this.activeSubscription,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      userType: json['user_type'],
      isActive: json['is_active'],
      gender: json['gender'],
      birthdate: json['birthdate'],
      area: json['area'] != null ? Area.fromJson(json['area']) : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      activeSubscription: json['active_subscription'] != null
          ? ActiveSubscription.fromJson(json['active_subscription'])
          : null,
    );
  }
}

class Area {
  final int id;
  final String name;

  Area({required this.id, required this.name});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
    );
  }
}

class City {
  final int id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ActiveSubscription {
  final String packageName;
  final String status;
  final int tasksRemaining;
  final int participantsRemaining;

  ActiveSubscription({
    required this.packageName,
    required this.status,
    required this.tasksRemaining,
    required this.participantsRemaining,
  });

  factory ActiveSubscription.fromJson(Map<String, dynamic> json) {
    return ActiveSubscription(
      packageName: json['package_name'],
      status: json['status'],
      tasksRemaining: json['tasks_remaining'],
      participantsRemaining: json['participants_remaining'],
    );
  }
}
