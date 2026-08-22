import 'package:shopping_app/features/notification/domain/entities/app_notification.dart';
import 'package:shopping_app/features/notification/domain/repo/notification_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Stream<List<AppNotification>> call() {
    return repository.getNotifications();
  }
}
