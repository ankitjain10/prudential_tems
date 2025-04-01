import 'dart:convert';

class EngineList {
  final List<Engine> engines;

  EngineList({required this.engines});

  // Factory method to create an instance from JSON
  factory EngineList.fromJson(Map<String, dynamic> json) {
    List engineList = json['engines'] as List;
    final List<Engine> engines =
        engineList.map((engineJson) => Engine.fromJson(engineJson)).toList();
    return EngineList(engines: engines);
  }

  // Convert the model to JSON format
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'engines': engines.map((Engine engine) => engine.toJson()).toList(),
    };
  }

  // Override the toString method to return a custom string representation
  @override
  String toString() {
    return 'EngineList(engines: [${engines.join(', ')}])';
  }
}

class Engine {
  final String id;
  final String manufacturer;
  final String model;
  final String type;
  final String thrust;
  final String weight;
  final String fuelConsumption;
  final String firstFlight;
  final List<String> application;

  Engine({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.type,
    required this.thrust,
    required this.weight,
    required this.fuelConsumption,
    required this.firstFlight,
    required this.application,
  });

  // Factory method to create an instance from JSON
  factory Engine.fromJson(Map<String, dynamic> json) {
    return Engine(
      id: json['id'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      type: json['type'],
      thrust: json['thrust'],
      weight: json['weight'],
      fuelConsumption: json['fuel_consumption'],
      firstFlight: json['first_flight'],
      application: List<String>.from(json['application']),
    );
  }

  // Convert the model to JSON format
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'manufacturer': manufacturer,
      'model': model,
      'type': type,
      'thrust': thrust,
      'weight': weight,
      'fuel_consumption': fuelConsumption,
      'first_flight': firstFlight,
      'application': application,
    };
  }

  // The copyWith method allows you to create a copy of the object with some fields modified.
  Engine copyWith({
    String? id,
    String? manufacturer,
    String? model,
    String? type,
    String? thrust,
    String? weight,
    String? fuelConsumption,
    String? firstFlight,
    List<String>? application,
  }) {
    return Engine(
      id: id ?? this.id,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      type: type ?? this.type,
      thrust: thrust ?? this.thrust,
      weight: weight ?? this.weight,
      fuelConsumption: fuelConsumption ?? this.fuelConsumption,
      firstFlight: firstFlight ?? this.firstFlight,
      application: application ?? this.application,
    );
  }

  // Override the toString method to return a custom string representation
  @override
  String toString() {
    return 'Engine(id: $id, manufacturer: $manufacturer, model: $model, type: $type, thrust: $thrust, weight: $weight, fuelConsumption: $fuelConsumption, firstFlight: $firstFlight, application: ${application.join(', ')})';
  }
}
