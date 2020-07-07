part 'aspect.g.dart';

class Aspect {
  final String name;
  final String description;

  const Aspect(this.name, this.description);

  factory Aspect.fromJson(Map<String, dynamic> json) => _$AspectFromJson(json);

  Map<String, dynamic> toJson() => _$AspectToJson(this);
}
