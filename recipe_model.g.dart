// GENERATED CODE - DO NOT MODIFY BY HAND
// This file is a stub. Run `flutter pub run build_runner build` to generate the actual adapters.

part of 'recipe_model.dart';

class RecipeModelAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 0;

  @override
  RecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      cuisine: fields[3] as String,
      tags: (fields[4] as List).cast<String>(),
      difficulty: fields[5] as String,
      prepTimeMin: fields[6] as int,
      cookTimeMin: fields[7] as int,
      servings: fields[8] as int,
      caloriesPerServing: fields[9] as int,
      rating: fields[10] as double,
      ratingCount: fields[11] as int,
      isFeatured: fields[12] as bool,
      isTrending: fields[13] as bool,
      description: fields[14] as String,
      imageUrl: fields[15] as String,
      author: fields[16] as String,
      nutritionData: (fields[17] as Map).cast<String, dynamic>(),
      ingredientsData: (fields[18] as List).map((e) => (e as Map).cast<String, dynamic>()).toList(),
      stepsData: (fields[19] as List).map((e) => (e as Map).cast<String, dynamic>()).toList(),
      videoUrl: fields[20] as String?,
      authorAvatar: fields[21] as String?,
      winePairing: fields[22] as String?,
      storage: fields[23] as String?,
      createdAt: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.category)
      ..writeByte(3)..write(obj.cuisine)
      ..writeByte(4)..write(obj.tags)
      ..writeByte(5)..write(obj.difficulty)
      ..writeByte(6)..write(obj.prepTimeMin)
      ..writeByte(7)..write(obj.cookTimeMin)
      ..writeByte(8)..write(obj.servings)
      ..writeByte(9)..write(obj.caloriesPerServing)
      ..writeByte(10)..write(obj.rating)
      ..writeByte(11)..write(obj.ratingCount)
      ..writeByte(12)..write(obj.isFeatured)
      ..writeByte(13)..write(obj.isTrending)
      ..writeByte(14)..write(obj.description)
      ..writeByte(15)..write(obj.imageUrl)
      ..writeByte(16)..write(obj.author)
      ..writeByte(17)..write(obj.nutritionData)
      ..writeByte(18)..write(obj.ingredientsData)
      ..writeByte(19)..write(obj.stepsData)
      ..writeByte(20)..write(obj.videoUrl)
      ..writeByte(21)..write(obj.authorAvatar)
      ..writeByte(22)..write(obj.winePairing)
      ..writeByte(23)..write(obj.storage)
      ..writeByte(24)..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
