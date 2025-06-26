import 'package:http/http.dart' as http;

class UserController {
  Future<bool> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://api.com/login'),
      body: {'email': email, 'password': password},
    );
    return response.statusCode == 200;
  }

  Future<bool> registerUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://api.com/register'),
      body: {'email': email, 'password': password},
    );
    return response.statusCode == 201;
  }
}
