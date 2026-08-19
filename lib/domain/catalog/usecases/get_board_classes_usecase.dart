import '../../common/result.dart';
import '../entities/board_class.dart';
import '../repositories/catalog_repository.dart';

/// Fetches every Admin-authored board/class row (enabled and disabled).
class GetBoardClassesUseCase {
  const GetBoardClassesUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<List<BoardClass>>> call() => _repository.getBoardClasses();
}
