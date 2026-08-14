sealed class Failure {
  const Failure();

  String get message;
}

class AssetLoadFailure extends Failure {
  const AssetLoadFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'Failed to load required data.${details != null ? ' $details' : ''}';
}

class ParsingFailure extends Failure {
  const ParsingFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'Failed to parse data.${details != null ? ' $details' : ''}';
}

class ValidationFailure extends Failure {
  const ValidationFailure(this.message);

  @override
  final String message;
}

class UnknownFailure extends Failure {
  const UnknownFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'Something went wrong.${details != null ? ' $details' : ''}';
}
