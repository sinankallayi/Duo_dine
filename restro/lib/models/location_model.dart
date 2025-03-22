// {longitude: 76.0111006, latitude: 11.2859043, timestamp: 1737384782451, accuracy: 10.522000312805176, altitude: -44.900001525878906, altitude_accuracy: 1.0, floor: null, heading: 0.0, heading_accuracy: 45.0, speed: 0.0, speed_accuracy: 1.5, is_mocked: false, gnss_satellite_count: 55.0, gnss_satellites_used_in_fix: 0.0}

class LocationModel {
  final double? longitude;
  final double? latitude;
  final int? timestamp;
  final double? accuracy;
  final double? altitude;
  final double? altitudeAccuracy;
  final double? floor;
  final double? heading;
  final double? headingAccuracy;
  final double? speed;
  final double? speedAccuracy;
  final bool? isMocked;
  final double? gnssSatelliteCount;
  final double? gnssSatellitesUsedInFix;

  LocationModel({
    this.longitude,
    this.latitude,
    this.timestamp,
    this.accuracy,
    this.altitude,
    this.altitudeAccuracy,
    this.floor,
    this.heading,
    this.headingAccuracy,
    this.speed,
    this.speedAccuracy,
    this.isMocked,
    this.gnssSatelliteCount,
    this.gnssSatellitesUsedInFix,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      longitude: json['longitude'],
      latitude: json['latitude'],
      timestamp: json['timestamp'],
      accuracy: json['accuracy'],
      altitude: json['altitude'],
      altitudeAccuracy: json['altitude_accuracy'],
      floor: json['floor'],
      heading: json['heading'],
      headingAccuracy: json['heading_accuracy'],
      speed: json['speed'],
      speedAccuracy: json['speed_accuracy'],
      isMocked: json['is_mocked'],
      gnssSatelliteCount: json['gnss_satellite_count'],
      gnssSatellitesUsedInFix: json['gnss_satellites_used_in_fix'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'timestamp': timestamp,
      'accuracy': accuracy,
      'altitude': altitude,
      'altitude_accuracy': altitudeAccuracy,
      'floor': floor,
      'heading': heading,
      'heading_accuracy': headingAccuracy,
      'speed': speed,
      'speed_accuracy': speedAccuracy,
      'is_mocked': isMocked,
      'gnss_satellite_count': gnssSatelliteCount,
      'gnss_satellites_used_in_fix': gnssSatellitesUsedInFix,
    };
  }
  
}
