// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AndroidInfoImpl _$$AndroidInfoImplFromJson(Map<String, dynamic> json) =>
    _$AndroidInfoImpl(
      json['release'] as String,
      json['sdkInt'] as int,
      json['manufacturer'] as String,
      json['model'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AndroidInfoImplToJson(_$AndroidInfoImpl instance) =>
    <String, dynamic>{
      'release': instance.release,
      'sdkInt': instance.sdkInt,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'runtimeType': instance.$type,
    };

_$IosInfoImpl _$$IosInfoImplFromJson(Map<String, dynamic> json) =>
    _$IosInfoImpl(
      json['systemName'] as String,
      json['version'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$IosInfoImplToJson(_$IosInfoImpl instance) =>
    <String, dynamic>{
      'systemName': instance.systemName,
      'version': instance.version,
      'runtimeType': instance.$type,
    };

_$OtherInfoImpl _$$OtherInfoImplFromJson(Map<String, dynamic> json) =>
    _$OtherInfoImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$OtherInfoImplToJson(_$OtherInfoImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };
