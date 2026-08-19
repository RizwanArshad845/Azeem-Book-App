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

class NetworkFailure extends Failure {
  const NetworkFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'No internet connection.${details != null ? ' $details' : ''}';
}

class ServerFailure extends Failure {
  const ServerFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'Something went wrong on our end.${details != null ? ' $details' : ''}';
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'You are not authorized to do this.${details != null ? ' $details' : ''}';
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([this.details]);

  final String? details;

  @override
  String get message => 'Not found.${details != null ? ' $details' : ''}';
}
