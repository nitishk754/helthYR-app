import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:health_wellness/model/question_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      "email": email, //"ernitish1993@gmail.com",
      "password": password, //"nitish123",
      "role": "user"
    });

    Response userData = await dio.post(baseUrl + userLogin, data: formData);

    // Prints the raw data returned by the server

    print('User Info: ${userData.data}');

    // Parsing the raw JSON data to the User class
    // Login user = Login.fromJson(userData.data);

    return jsonDecode(userData.data.toString());
  }

  Future<Map> resetPassword(String authorization, inputs) async {
    var formData = jsonEncode(inputs);

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] = 'Bearer $authorization';
    var userData = await dio.post(baseUrl + userResetPassword, data: formData);

    return jsonDecode(userData.data.toString());
  }

  Future<Map> saveQuestions(String authorization, inputs) async {
    var formData = jsonEncode(inputs);

    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] = 'Bearer $authorization';
    var userData = await dio.post(baseUrl + questions, data: formData);

    return jsonDecode(userData.data.toString());
  }
  Future<Map> addWaterIntake(String intakeAmount) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString("_token")}';
    // var formData = jsonEncode({"email": email, "password": pass});
    var formData = jsonEncode({
      "intake_amount": intakeAmount,
      "intake_measurement": "ltr"
    });
    Response userData = await dio.post(baseUrl + waterIntake, data: formData);
    return jsonDecode(userData.data.toString());
  }

  Future<Map> getSevenDaysWaterIntake(String intakeAmount) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString("_token")}';
    // var formData = jsonEncode({"email": email, "password": pass});
    var formData = jsonEncode({
      "intake_amount": intakeAmount,
      "intake_measurement": "ltr"
    });
    Response userData = await dio.get(baseUrl + waterIntake, data: formData);
    return jsonDecode(userData.data.toString());
  }

  Future<Map> loadActivity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString("_token")}';
    print(dio.options.headers['Authorization']);
    Response userData = await dio.get("${baseUrl + activity}?range=today");
    print(userData);
    return jsonDecode(userData.data.toString());
  }

  Future<Map> saveActivity(String activityType, String duration, String intensity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString("_token")}';
    // var formData = jsonEncode({"email": email, "password": pass});
    var formData = jsonEncode({
      "date": getCurrentDate(),
      "activity_type": activityType,
      "duration": duration == "" ? "0":duration,
      "intensity": intensity
    });
    print(formData);
    Response userData = await dio.post(baseUrl + activity, data: formData);
    return jsonDecode(userData.data.toString());
  }

  Future<Map> meals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    dio.options.headers['X-Authorization'] = auth;
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString("_token")}';
    print(dio.options.headers['Authorization']);
    Response userData = await dio.get(baseUrl + mealPlan);
    
    return jsonDecode(userData.data.toString());
  }
}

String getCurrentDate() {
  var date = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  // var dateParse = DateTime.parse(date);

  // var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
  return formatter.format(date);
}