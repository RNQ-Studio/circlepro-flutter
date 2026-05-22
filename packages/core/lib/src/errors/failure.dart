sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('Unauthorized');
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure() : super('Unknown error');
}
