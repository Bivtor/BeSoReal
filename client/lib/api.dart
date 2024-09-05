import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future<String?> genericPOST({
  required String url,
  required Map<String, dynamic> body
}) async {

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return 'User is not logged in';
  }
  var userToken = await user.getIdToken();

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Success: ${response.body}');
      return null;
    } else {
      print('Failed to complete request. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      var errorJson = jsonDecode(response.body);
      return errorJson['error'];
    }
  } catch (error) {
    print('Error: $error');
    return 'Error: $error';
  }
}

Future<String?> updateAccount(String username, String displayName) async {
  return await genericPOST(
    url: "https://fovp451r9d.execute-api.us-west-1.amazonaws.com/main/updateUser",
    body: {
      'username': username,
      'displayName': displayName,
    },
  );
}
