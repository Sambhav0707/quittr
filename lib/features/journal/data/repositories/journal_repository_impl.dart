import 'package:dartz/dartz.dart';
import 'package:quittr/core/database/database_helper.dart';
import 'package:quittr/core/error/failures.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../models/journal_entry_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  final DatabaseHelper _databaseHelper;

  JournalRepositoryImpl({
    required DatabaseHelper databaseHelper,
  }) : _databaseHelper = databaseHelper;

  @override
  Future<Either<Failure, List<JournalEntry>>> getEntries() async {
    try {
      final entries = await _databaseHelper.getAllJournalEntries();
      return Right(entries);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> addEntry(
      String title, String description) async {
    try {
      final entry = JournalEntryModel(
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );
      final savedEntry = await _databaseHelper.createJournalEntry(entry);
      return Right(savedEntry);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
