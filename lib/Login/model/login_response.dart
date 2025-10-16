class LoginResponse {
  final String code;
  final String? doctorId;
  final String? image;
  final String? name;
  final String? trakcareCode;

  LoginResponse({
    required this.code,
    this.doctorId,
    this.image,
    this.name,
    this.trakcareCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] ?? '',
      doctorId: json['doctorID'],
      image: json['image'],
      name: json['name'],
      trakcareCode: json['trakcareCode'],
    );
  }
}