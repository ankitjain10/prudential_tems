import 'dart:async';
import 'dart:convert';
import 'package:prudential_tems/config/api_config.dart';
import 'package:prudential_tems/features/home/data/models/engine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});

class NetworkService {
  final Dio _dio = Dio();

  Future<List<Engine>> fetchEngineList() async {
    try {
      //mock api call
      final jsonResponse = jsonDecode(jsonString)['engines'];
      final futureDynamicList =
          jsonResponse
              .map((engineJson) => Engine.fromJson(engineJson))
              .toList();
      final List<Engine> engineList = List<Engine>.from(futureDynamicList);
      final FutureOr<List<Engine>> futureOrEngineList = engineList;
      return futureOrEngineList;

      //api call
      /*await _dio.get(ApiConfig.baseUrl+ApiConfig.getUsers);
      final data = response.data;
      return data.map((json) => Engine.fromJson(json)).toList();*/
    } catch (e) {
      rethrow;
    }
  }
}

String jsonString = '''{ 
    "engines": [
      {
        "id": "1",
        "manufacturer": "Rolls-Royce",
        "model": "Trent 1000",
        "type": "Turbofan",
        "thrust": "78,000 lbf",
        "weight": "6,300 kg",
        "fuel_consumption": "2.25 lb/min",
        "first_flight": "2007-08-30",
        "application": ["Boeing 787 Dreamliner"],
        "imageUrl" : ""
      },
      {
        "id": "2",
        "manufacturer": "General Electric",
        "model": "CF6-80C2",
        "type": "Turbofan",
        "thrust": "62,000 lbf",
        "weight": "4,800 kg",
        "fuel_consumption": "2.15 lb/min",
        "first_flight": "1985-06-26",
        "application": ["Airbus A300", "Boeing 747-400"],
        "imageUrl" : ""
      },
      {
        "id": "3",
        "manufacturer": "Pratt & Whitney",
        "model": "PW4000",
        "type": "Turbofan",
        "thrust": "66,500 lbf",
        "weight": "4,500 kg",
        "fuel_consumption": "2.25 lb/min",
        "first_flight": "1987-03-29",
        "application": ["Boeing 777", "Airbus A310"],
        "imageUrl" : ""
      },
      {
        "id": "4",
        "manufacturer": "CFM International",
        "model": "CFM56-5B",
        "type": "Turbofan",
        "thrust": "27,000 lbf",
        "weight": "2,000 kg",
        "fuel_consumption": "1.80 lb/min",
        "first_flight": "1994-04-20",
        "application": ["Airbus A320"],
        "imageUrl" : ""
      },
      {
        "id": "5",
        "manufacturer": "Turbomeca",
        "model": "Ardiden 3C",
        "type": "Turboshaft",
        "thrust": "1,100 shp",
        "weight": "290 kg",
        "fuel_consumption": "0.8 lb/min",
        "first_flight": "2007-09-15",
        "application": ["Eurocopter EC175", "AgustaWestland AW139"],
        "imageUrl" : ""
      },
       {
        "id": "1",
        "manufacturer": "Rolls-Royce",
        "model": "Trent 1000",
        "type": "Turbofan",
        "thrust": "78,000 lbf",
        "weight": "6,300 kg",
        "fuel_consumption": "2.25 lb/min",
        "first_flight": "2007-08-30",
        "application": ["Boeing 787 Dreamliner"],
        "imageUrl" : ""
      },
      {
        "id": "2",
        "manufacturer": "General Electric",
        "model": "CF6-80C2",
        "type": "Turbofan",
        "thrust": "62,000 lbf",
        "weight": "4,800 kg",
        "fuel_consumption": "2.15 lb/min",
        "first_flight": "1985-06-26",
        "application": ["Airbus A300", "Boeing 747-400"],
        "imageUrl" : ""
      },
      {
        "id": "3",
        "manufacturer": "Pratt & Whitney",
        "model": "PW4000",
        "type": "Turbofan",
        "thrust": "66,500 lbf",
        "weight": "4,500 kg",
        "fuel_consumption": "2.25 lb/min",
        "first_flight": "1987-03-29",
        "application": ["Boeing 777", "Airbus A310"],
        "imageUrl" : ""
      },
      {
        "id": "4",
        "manufacturer": "CFM International",
        "model": "CFM56-5B",
        "type": "Turbofan",
        "thrust": "27,000 lbf",
        "weight": "2,000 kg",
        "fuel_consumption": "1.80 lb/min",
        "first_flight": "1994-04-20",
        "application": ["Airbus A320"],
        "imageUrl" : ""
      },
      {
        "id": "5",
        "manufacturer": "Turbomeca",
        "model": "Ardiden 3C",
        "type": "Turboshaft",
        "thrust": "1,100 shp",
        "weight": "290 kg",
        "fuel_consumption": "0.8 lb/min",
        "first_flight": "2007-09-15",
        "application": ["Eurocopter EC175", "AgustaWestland AW139"],
        "imageUrl" : ""
      },
       {
        "id": "1",
        "manufacturer": "Rolls-Royce",
        "model": "Trent 1000",
        "type": "Turbofan",
        "thrust": "78,000 lbf",
        "weight": "6,300 kg",
        "fuel_consumption": "2.25 lb/min",
        "first_flight": "2007-08-30",
        "application": ["Boeing 787 Dreamliner"],
        "imageUrl" : ""
      },
      {
        "id": "2",
        "manufacturer": "General Electric",
        "model": "CF6-80C2",
        "type": "Turbofan",
        "thrust": "62,000 lbf",
        "weight": "4,800 kg",
        "fuel_consumption": "2.15 lb/min",
        "first_flight": "1985-06-26",
        "application": ["Airbus A300", "Boeing 747-400"],
        "imageUrl" : ""
      },
      {
        "id": "3",
        "manufacturer": "Pratt & Whitney",
        "model": "PW4000",
        "type": "Turbofan",
        "thrust": "66,500 lbf",
        "weight": "4,500 kg",
        "fuel_consumption": "2.25 lb/min",
        "first_flight": "1987-03-29",
        "application": ["Boeing 777", "Airbus A310"],
        "imageUrl" : ""
      },
      {
        "id": "4",
        "manufacturer": "CFM International",
        "model": "CFM56-5B",
        "type": "Turbofan",
        "thrust": "27,000 lbf",
        "weight": "2,000 kg",
        "fuel_consumption": "1.80 lb/min",
        "first_flight": "1994-04-20",
        "application": ["Airbus A320"],
        "imageUrl" : ""
      },
      {
        "id": "5",
        "manufacturer": "Turbomeca",
        "model": "Ardiden 3C",
        "type": "Turboshaft",
        "thrust": "1,100 shp",
        "weight": "290 kg",
        "fuel_consumption": "0.8 lb/min",
        "first_flight": "2007-09-15",
        "application": ["Eurocopter EC175", "AgustaWestland AW139"],
        "imageUrl" : ""
      }, {
        "id": "1",
        "manufacturer": "Rolls-Royce",
        "model": "Trent 1000",
        "type": "Turbofan",
        "thrust": "78,000 lbf",
        "weight": "6,300 kg",
        "fuel_consumption": "2.25 lb/min",
        "first_flight": "2007-08-30",
        "application": ["Boeing 787 Dreamliner"],
        "imageUrl" : ""
      },
      {
        "id": "2",
        "manufacturer": "General Electric",
        "model": "CF6-80C2",
        "type": "Turbofan",
        "thrust": "62,000 lbf",
        "weight": "4,800 kg",
        "fuel_consumption": "2.15 lb/min",
        "first_flight": "1985-06-26",
        "application": ["Airbus A300", "Boeing 747-400"],
        "imageUrl" : ""
      },
      {
        "id": "3",
        "manufacturer": "Pratt & Whitney",
        "model": "PW4000",
        "type": "Turbofan",
        "thrust": "66,500 lbf",
        "weight": "4,500 kg",
        "fuel_consumption": "2.25 lb/min",
        "first_flight": "1987-03-29",
        "application": ["Boeing 777", "Airbus A310"],
        "imageUrl" : ""
      },
      {
        "id": "4",
        "manufacturer": "CFM International",
        "model": "CFM56-5B",
        "type": "Turbofan",
        "thrust": "27,000 lbf",
        "weight": "2,000 kg",
        "fuel_consumption": "1.80 lb/min",
        "first_flight": "1994-04-20",
        "application": ["Airbus A320"],
        "imageUrl" : ""
      },
      {
        "id": "5",
        "manufacturer": "Turbomeca",
        "model": "Ardiden 3C",
        "type": "Turboshaft",
        "thrust": "1,100 shp",
        "weight": "290 kg",
        "fuel_consumption": "0.8 lb/min",
        "first_flight": "2007-09-15",
        "application": ["Eurocopter EC175", "AgustaWestland AW139"],
        "imageUrl" : ""
      }
    ]
  }''';
