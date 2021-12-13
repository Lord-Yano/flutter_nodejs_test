import 'dart:convert';

import 'package:weighttracker_flutter/network_utils/api.dart';
import 'package:weighttracker_flutter/widgets/toast.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

Weight weightFromJson(String str) => Weight.fromJson(json.decode(str));

String weightToJson(Weight data) => json.encode(data.toJson());

class Weight {
  Weight({
    required this.weights,
  });

  List<WeightElement> weights = [];

  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
        weights: List<WeightElement>.from(
            json["weights"].map((x) => WeightElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "weights": List<dynamic>.from(weights.map((x) => x.toJson())),
      };
}

class WeightElement {
  WeightElement({
    required this.id,
    required this.unit,
    required this.weight,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String unit;
  int weight;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;

  factory WeightElement.fromJson(Map<String, dynamic> json) => WeightElement(
        id: json["_id"],
        unit: json["unit"],
        weight: json["weight"],
        userId: json["userID"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "unit": unit,
        "weight": weight,
        "userID": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };

  Future<List<WeightElement>> getAll() async {
    try {
      final res = await Network().getData("/weight/get_weight_history/");
      if (res.statusCode == 200) {
        // ignore: avoid_print
        print("here 1");
        final Weight _weightsHistory = weightFromJson(res.body);
        // ignore: avoid_print
        print(_weightsHistory.weights);
        return _weightsHistory.weights;
      } else {
        // ignore: avoid_print
        print("here 2");
        final body = json.decode(res.body);
        toast(body["message"], "error");
        return Weight(weights: []).weights;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return Weight(weights: []).weights;
    }
  }

  Future<WeightElement> save(Map data) async {
    try {
      final res = await Network().postData(data, "/weight/save_weight");
      final body = json.decode(res.body);
      if (res.statusCode == 200) {
        final jsonWeight = body["weight"];
        final WeightElement weight = WeightElement.fromJson(jsonWeight);
        return weight;
      } else {
        toast(body["message"], "error");
        return WeightElement(
          id: '',
          unit: '',
          weight: 0,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      return WeightElement(
        id: '',
        unit: '',
        weight: 0,
        userId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<WeightElement> update(Map data) async {
    try {
      final res = await Network().postData(data, "/weight/update_weight");
      final body = json.decode(res.body);
      if (res.statusCode == 200) {
        final jsonWeight = body["weight"];
        final WeightElement weight = WeightElement.fromJson(jsonWeight);
        return weight;
      } else {
        toast(body["message"], "error");
        return WeightElement(
          id: '',
          unit: '',
          weight: 0,
          userId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      return WeightElement(
        id: '',
        unit: '',
        weight: 0,
        userId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<bool> delete(String id) async {
    try {
      final res = await Network().getData("/weight/delete_weight/" + id);
      if (res.statusCode == 200) {
        return true;
      } else {
        final body = json.decode(res.body);
        toast(body["message"], "error");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(""));
      return true;
    } catch (e) {
      return false;
    }
  }
}
