import 'package:shopping_app/features/notification/domain/repo/notification_repository.dart';

class CreateLoginNotification {
  final NotificationRepository repository;

  CreateLoginNotification(this.repository);

  Future<void> call() async {
    await repository.createLoginNotification();
  }
}
