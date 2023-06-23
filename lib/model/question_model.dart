// To parse this JSON data, do
//
//     final questionModel = questionModelFromJson(jsonString);

import 'dart:convert';

QuestionModel questionModelFromJson(String str) =>
    QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());



class QuestionModel {
  Data data;
  Meta meta;

  

  QuestionModel({
    required this.data,
    required this.meta,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        data: Data.fromJson(json["data"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "meta": meta.toJson(),
      };
}

class Data {
  String status;
  String message;
  List<Datum> data;

  Data({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String qTxt;
  String qType;
  int isUnit;
  String? unitValues;
  int isNextScreen;
  String category;
  dynamic tagId;
  dynamic tagName;
  DateTime createdAt;
  DateTime updatedAt;
  List<Choice> choice;

  Datum({
    required this.id,
    required this.qTxt,
    required this.qType,
    required this.isUnit,
    required this.unitValues,
    required this.isNextScreen,
    required this.category,
    required this.tagId,
    required this.tagName,
    required this.createdAt,
    required this.updatedAt,
    required this.choice,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        qTxt: json["q_txt"],
        qType: json["q_type"],
        isUnit: json["is_unit"],
        unitValues: json["unit_values"],
        isNextScreen: json["is_next_screen"],
        category: json["category"],
        tagId: json["tag_id"],
        tagName: json["tag_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        choice:
            List<Choice>.from(json["choice"].map((x) => Choice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "q_txt": qTxt,
        "q_type": qType,
        "is_unit": isUnit,
        "unit_values": unitValues,
        "is_next_screen": isNextScreen,
        "category": category,
        "tag_id": tagId,
        "tag_name": tagName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "choice": List<dynamic>.from(choice.map((x) => x.toJson())),
      };
}

class Choice {
  int id;
  int questionId;
  String choiceText;
  DateTime createdAt;
  DateTime updatedAt;

  Choice({
    required this.id,
    required this.questionId,
    required this.choiceText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        id: json["id"],
        questionId: json["question_id"],
        choiceText: json["choice_text"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "choice_text": choiceText,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Meta {
  int timestamp;

  Meta({
    required this.timestamp,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
      };
}
