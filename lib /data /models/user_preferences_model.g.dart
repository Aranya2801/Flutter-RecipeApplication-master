// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'user_preferences_model.dart';

class UserPreferencesModelAdapter extends TypeAdapter<UserPreferencesModel> {
  @override
  final int typeId = 1;

  @override
  UserPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferencesModel(
      userName: fields[0] as String,
      userAvatar: fields[1] as String?,
      dietaryPreferences: (fields[2] as List).cast<String>(),
      allergens: (fields[3] as List).cast<String>(),
      dailyCalorieGoal: fields[4] as int,
      skillLevel: fields[5] as String,
      notificationsEnabled: fields[6] as bool,
      preferredCuisine: fields[7] as String,
      weeklyMealPlanDays: fields[8] as int,
      hasCompletedOnboarding: fields[9] as bool,
      searchHistory: (fields[10] as List).cast<String>(),
      measurementSystem: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferencesModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)..write(obj.userName)
      ..writeByte(1)..write(obj.userAvatar)
      ..writeByte(2)..write(obj.dietaryPreferences)
      ..writeByte(3)..write(obj.allergens)
      ..writeByte(4)..write(obj.dailyCalorieGoal)
      ..writeByte(5)..write(obj.skillLevel)
      ..writeByte(6)..write(obj.notificationsEnabled)
      ..writeByte(7)..write(obj.preferredCuisine)
      ..writeByte(8)..write(obj.weeklyMealPlanDays)
      ..writeByte(9)..write(obj.hasCompletedOnboarding)
      ..writeByte(10)..write(obj.searchHistory)
      ..writeByte(11)..write(obj.measurementSystem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
