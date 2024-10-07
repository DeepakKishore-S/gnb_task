import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? avatarUrl; // Nullable

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl, // Allow this to be nullable
  });
}
