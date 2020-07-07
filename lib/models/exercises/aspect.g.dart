// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aspect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Aspect _$AspectFromJson(Map<String, dynamic> json) {
  return Aspect((json['name'] as String), (json['description'] as String));
}

Map<String, dynamic> _$AspectToJson(Aspect instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
