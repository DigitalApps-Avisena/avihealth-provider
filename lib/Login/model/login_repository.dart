import 'dart:convert';
import 'package:avihealth_provider/login/model/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginRepository {
  final storage = const FlutterSecureStorage();

  Future<LoginResponse> login(String email, String password) async {
    final uri = Uri.parse('http://10.10.0.37/avstc/appRestApiCareProvider/loginCareProvider');

    final response = await http.post(uri, body: {
      'email': email,
      'password': password,
    });

    final data = jsonDecode(response.body);

    final loginResponse = LoginResponse.fromJson(data);

    if (loginResponse.code == '1') {
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'doctorId', value: loginResponse.doctorId ?? '');
      await storage.write(key: 'image', value: loginResponse.image ?? '');
      await storage.write(key: 'name', value: loginResponse.name ?? '');
      await storage.write(key: 'trakcareCode', value: loginResponse.trakcareCode ?? '');
    }

    return loginResponse;
  }
}