enum ClassLevel { ninth, tenth, eleventh, twelfth }

extension ClassLevelX on ClassLevel {
  String get label {
    switch (this) {
      case ClassLevel.ninth:
        return '9th';
      case ClassLevel.tenth:
        return '10th';
      case ClassLevel.eleventh:
        return '11th';
      case ClassLevel.twelfth:
        return '12th';
    }
  }
}
