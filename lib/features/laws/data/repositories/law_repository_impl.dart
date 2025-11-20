import 'package:nomos_app/features/laws/domain/entities/law.dart';
import 'package:nomos_app/features/laws/domain/repositories/law_repository.dart';
import 'package:nomos_app/features/laws/data/datasources/law_remote_datasource.dart';

class LawRepositoryImpl implements LawRepository {
  final LawRemoteDataSource remoteDataSource;

  LawRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Law>> getLaws() async {
    return await remoteDataSource.getLaws();
  }
}
