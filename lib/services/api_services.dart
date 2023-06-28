import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:health_wellness/model/question_model.dart';

import '../constants/urls.dart';

final dio = Dio();

class ApiService {
  Future<QuestionModel> getQuestion() async {
    dio.options.headers['X-Authorization'] = auth;
    // dio.interceptors.add(InterceptorsWrapper(onResponse: (response, handler) {
    //   response.data = jsonDecode(response.data as String);

    //   print('Questions Info: ${response.headers}');
    //   print('Questions Info: ${jsonEncode(response.data)}');
    // //   QuestionModel  questionModel = QuestionModel.fromJson(response.data);
    // // print('Questions Info ggrg: ${jsonEncode(questionModel.data.data.length)}');
    // }));
    Response questionData = await dio.get(
      baseUrl + questions,
    );
    questionData.data = jsonDecode(questionData.data as String);
    print('Questions Info: ${questionData.headers}');
    print('Questions Info: ${jsonEncode(questionData.data)}');
    // Prints the raw data returned by the server

    // Parsing the raw JSON data to the User class

    // var questionModel2 = questionModel;
    QuestionModel questionModel = QuestionModel.fromJson(questionData.data);
    return questionModel;
  }

  Future<Map> getUser(String email, String password) async {
    // var formData = jsonEncode({"email": email, "password": pass});
    var formData = jsonEncode({
      "email": email, // "ernitish1993@gmail.com",
      "password": password, // "nitish123",
      "role": "user"
    });
    Response userData = await dio.post(baseUrl + userLogin, data: formData);

    // Prints the raw data returned by the server

    print('User Info: ${userData.data}');

    // Parsing the raw JSON data to the User class
    // Login user = Login.fromJson(userData.data);

    return jsonDecode(userData.data.toString());
  }

  Future<Map> resetPassword(
      String auth, String password, String passwordConfirmation) async {
    // var formData = jsonEncode({"email": email, "password": pass});
    var formData = jsonEncode(
        {"password": "nitish123", "password_confirmation": "nitish123"});

    dio.options.headers['Authorization'] = 'Bearer $auth';
    Response userData =
        await dio.post(baseUrl + userResetPassword, data: formData);

    // Prints the raw data returned by the server

    print('User Info: ${userData.data}');

    // Parsing the raw JSON data to the User class
    // Login user = Login.fromJson(userData.data);

    return jsonDecode(userData.data.toString());
  }
}
