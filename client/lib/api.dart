import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> genericRequest(
    {required String url,
    required String method,
    Map<String, dynamic>? body}) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return { 'error': 'User is not logged in' };
  }
  var userToken = await user.getIdToken();

  try {
    http.Response response;

    if (method == 'POST') {
      response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
        body: jsonEncode(body),
      );
    } else if (method == 'DELETE') {
      response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
        body: jsonEncode(body),
      );
    } else if (method == 'GET') {
      response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );
    } else {
      return { 'error': 'Unsupported method: $method' };
    }

    if (response.statusCode == 200) {
      print('Success: ${response.body}');

      if (method == 'GET') return jsonDecode(response.body);

      return {
        'success': jsonDecode(response.body),
      };
    } else {
      var errorJson = jsonDecode(response.body);
      print('Failed: ${response.statusCode.toString()} $errorJson');
      return { 'error': errorJson['error'] };
    }
  } catch (error) {
    print('Error: $error');
    return { 'error': error };
  }
}

Future<Map<String, dynamic>> getUserInfo() async {
  return await genericRequest(
    url: "https://fovp451r9d.execute-api.us-west-1.amazonaws.com/main/user",
    method: 'GET'
  );
}

Future<Map<String, dynamic>> updateAccount(String username, String displayName) async {
  return await genericRequest(
    url: "https://fovp451r9d.execute-api.us-west-1.amazonaws.com/main/user",
    method: 'POST',
    body: {
      'username': username,
      'displayName': displayName,
    },
  );
}

Future<Map<String, dynamic>> addFriend(String username) async {
  return await genericRequest(
    url: "https://fovp451r9d.execute-api.us-west-1.amazonaws.com/main/friend",
    method: 'POST',
    body: {
      'username': username,
    },
  );
}

Future<Map<String, dynamic>> removeFriend(String targetUserID) async {
  return await genericRequest(
    url: "https://fovp451r9d.execute-api.us-west-1.amazonaws.com/main/friend",
    method: 'DELETE',
    body: {
      'targetUserID': targetUserID,
    },
  );
}

Future<Map<String, dynamic>> getFriends() async {
  return await genericRequest(
    url: "https://fovp451r9d.execute-api.us-west-1.amazonaws.com/main/friends",
    method: 'GET'
  );
}
