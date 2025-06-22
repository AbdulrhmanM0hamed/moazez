class EditProfileParams {
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? birthdate;
  final String? areaId;
  final String? cityId;
  final String? avatarPath;

  EditProfileParams({
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthdate,
    this.areaId,
    this.cityId,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'birthdate': birthdate,
      'area_id': areaId,
      'city_id': cityId,
    };
  }
}
