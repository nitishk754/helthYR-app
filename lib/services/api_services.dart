import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_wellness/model/question_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/urls.dart';
import 'dart:developer';

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
    // questionData.data = jsonDecode(questionData.data as String);
    print('Questions Info: ${questionData.headers}');
    print('Questions Info: ${jsonEncode(questionData.data)}');
    // Prints the raw data returned by the server

    // Parsing the raw JSON data to the User class

    // var questionModel2 = questionModel;
    QuestionModel questionModel = QuestionModel.fromJson(questionData.data);
    return questionModel;
  }

  Future getUser(String email, String password) async {
    // var formData = jsonEncode({"email": email, "password": pass});
    dio.options.headers['Accept'] = "application/json";
    var formData = jsonEncode({
      "email": email, //"ernitish1993@gmail.com",
      "password": password, //"nitish123",
      "role": "user"
    });
    Response? userData;
    try {
      userData = await dio.post(baseUrl + userLogin, data: formData);
      return userData.data;
    } on DioException catch (e) {
      print(e.response!.statusCode);
      Fluttertoast.showToast(
          msg: "These credentials do not match our records.");

      // print("error: ${e.response?.data}");
      var abc = e.response!.data;

      print("error: ${(abc)}");
      return (abc);
    }

    // Prints the raw data returned by the server
    print('User Info: ${formData.toString()}');

    print('User Info: ${userData?.data}');

    // Parsing the raw JSON data to the User class
    // Login user = Login.fromJson(userData.data);
  }

  Future resetPassword(String authorization, inputs) async {
    var formData = jsonEncode(inputs);

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Accept'] = "application/json";
    dio.options.headers['Authorization'] = 'Bearer $authorization';
    Response? userData;
    try {
      userData = await dio.post(baseUrl + userResetPassword, data: formData);
      return (userData.data);
    } on DioException catch (e) {
      print("errorRes: ${e.response!.statusCode}");
      print("errorRes: ${e.response!.data}");
      var returnError = e.response!.data;
      return returnError;
    }
    // print('User Info1: ${(userData.data)}');
    // return (userData.data);
  }

  Future saveQuestions(String authorization, inputs) async {
    var formData = jsonEncode(inputs);
    print('User Info10: ${formData}');

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Accept'] = "application/json";
    dio.options.headers['Authorization'] = 'Bearer $authorization';
    try {
      var userData = await dio.post(baseUrl + questions, data: formData);
      debugPrint(jsonEncode(inputs.toString()));

      return userData.data;
    } on DioException catch (e) {
      print("errorRes: ${e.response!.statusCode}");
      print("errorRes: ${e.response!.data}");
      var returnError = e.response!.data;
      return returnError;
    }
  }

  Future<Map> addWaterIntake(String intakeAmount) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    // var formData = jsonEncode({"email": email, "password": pass});
    var formData = jsonEncode(
        {"intake_amount": intakeAmount, "intake_measurement": "ltr"});
    debugPrint(formData.toString());
    Response userData = await dio.post(baseUrl + waterIntake, data: formData);
    return userData.data;
  }

  Future<Map> getSevenDaysWaterIntake(String intakeAmount) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    // var formData = jsonEncode({"email": email, "password": pass});
    var formData = jsonEncode(
        {"intake_amount": intakeAmount, "intake_measurement": "ltr"});
    Response userData = await dio.get(baseUrl + waterIntake, data: formData);
    return userData.data;
  }

  Future<Map> loadActivity(String dateVal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    print(dio.options.headers['Authorization']);
    Response userData =
        await dio.get("${baseUrl + activity}?range=today&date=${dateVal}");
    print(userData);
    return userData.data;
  }

  Future<Map> saveActivity(
      String activityType, String duration, String intensity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    // var formData = jsonEncode({"email": email, "password": pass});
    var formData = jsonEncode({
      "date": getCurrentDate(),
      "activity_type": activityType,
      "duration": duration == "" ? "0" : duration,
      "intensity": intensity
    });
    print(formData);
    Response userData = await dio.post(baseUrl + activity, data: formData);
    return userData.data;
  }

  Future<Map> meals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    print(dio.options.headers['Authorization']);
    Response userData = await dio.get(baseUrl + mealPlan);

    print(userData.data);
    // print(jsonDecode(userData.data.toString()));

    return userData.data;
  }

  Future<Map> saveMeals(String recipe_id, String meal_type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    var formData = jsonEncode({
      "recipe_id": recipe_id, //"ernitish1993@gmail.com",
      "meal_type": meal_type, //"nitish123",
      // "role": "user"
    });
    print(dio.options.headers['Authorization']);
    print(formData);
    Response saveMealData = await dio.post(baseUrl + mealPlan, data: formData);

    print(saveMealData.data);
    // print(jsonDecode(userData.data.toString()));

    return saveMealData.data;
  }

  Future<Map> postLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    print(dio.options.headers['Authorization']);
    Response userData = await dio.post(baseUrl + logout);

    // print(jsonDecode(userData.data.toString()));
    // print(jsonDecode(userData.data.toString()));
    print(userData.data.toString());

    return userData.data;
  }

  Future<Map> getDashboard() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    print(dio.options.headers['Authorization']);

    try {
      Response dashboardData = await dio.get(baseUrl + dashboard);
      print("dashboard: ${(dashboardData.data.toString())}");

      return dashboardData.data;
    } on DioException catch (e) {
      print("errorResProfile: ${e.response!.statusCode}");
      print("errorResProfile: ${e.response!.data}");
      var returnError = e.response!.data;
      return returnError;
    }

    // print(jsonDecode(userData.data.toString()));
  }

  Future<Map> userProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Accept'] = "application/json";
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';
    //  var userData;

    try {
      Response userProfile = await dio.get(baseUrl + profile);
      // log(dashboardData.data.toString());
      print("userDataProfile: ${userProfile.data}");
      return (userProfile.data);
    } on DioException catch (e) {
      print("errorResProfile: ${e.response!.statusCode}");
      print("errorResProfile: ${e.response!.data}");
      var returnError = e.response!.data;
      return returnError;
    }
    // print('User Info1: ${(userData.data)}');
    // return (userData.data);
  }

  Future<Map> getNutrientData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Accept'] = "application/json";
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString("_token")}';

    try {
      Response userNutrientData = await dio.get(baseUrl + nutrientData);
      // log(dashboardData.data.toString());
      print("userDataProfile: ${userNutrientData.data}");
      return (userNutrientData.data);
    } on DioException catch (e) {
      print("errorResProfile: ${e.response!.statusCode}");
      print("errorResProfile: ${e.response!.data}");
      var returnError = e.response!.data;
      return returnError;
    }
  }
}

String getCurrentDate() {
  var date = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  // var dateParse = DateTime.parse(date);

  // var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
  return formatter.format(date);
}
