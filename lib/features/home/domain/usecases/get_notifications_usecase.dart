import '../repositories/home_repository.dart';

/// Use case pour récupérer les notifications
class GetNotificationsUseCase {
  final HomeRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getRecentNotifications();
  }
}

