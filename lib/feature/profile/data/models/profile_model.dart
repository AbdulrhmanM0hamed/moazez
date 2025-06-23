class ProfileResponse {
  final ProfileData data;

  ProfileResponse({required this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(data: ProfileData.fromJson(json['data']));
  }
}

class ProfileData {
  final UserProfile user;

  ProfileData({required this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(user: UserProfile.fromJson(json['user']));
  }
}

class UserProfile {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? avatarUrl;
  final String? userType;
  final bool? isActive;
  final String? gender;
  final String? birthdate;
  final Area? area;
  final City? city;
  final ActiveSubscription? activeSubscription;

  UserProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.avatarUrl,
    this.userType,
    this.isActive,
    this.gender,
    this.birthdate,
    this.area,
    this.city,
    this.activeSubscription,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      userType: json['user_type'] as String?,
      isActive: json['is_active'] as bool?,
      gender: json['gender'] as String?,
      birthdate: json['birthdate'] as String?,
      area: json['area'] != null ? Area.fromJson(json['area']) : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      activeSubscription:
          json['active_subscription'] != null
              ? ActiveSubscription.fromJson(json['active_subscription'])
              : null,
    );
  }
}

class Area {
  final int? id;
  final String? name;

  Area({this.id, this.name});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(id: json['id'] as int?, name: json['name'] as String?);
  }
}

class City {
  final int? id;
  final String? name;

  City({this.id, this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(id: json['id'] as int?, name: json['name'] as String?);
  }
}

class ActiveSubscription {
  final String? packageName;
  final String? status;
  final int? tasksRemaining;
  final int? participantsRemaining;

  ActiveSubscription({
    this.packageName,
    this.status,
    this.tasksRemaining,
    this.participantsRemaining,
  });

  factory ActiveSubscription.fromJson(Map<String, dynamic> json) {
    return ActiveSubscription(
      packageName: json['package_name'] as String?,
      status: json['status'] as String?,
      tasksRemaining: json['tasks_remaining'] as int?,
      participantsRemaining: json['participants_remaining'] as int?,
    );
  }
}
