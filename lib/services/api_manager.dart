import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:github_api_connect/constants/strings.dart';
import 'package:github_api_connect/models/gitusersmodel.dart';

// ignore: camel_case_types
class API_Manager {
  Future<gitUserModel> getUserDetails(String userName) async {
    var client = http.Client();
    var gitUsrMdl;

    try {
      var response = await client.get(Strings.github_users_url + userName);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        gitUsrMdl = gitUserModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      return gitUsrMdl;
    }

    return gitUsrMdl;
  }
}
