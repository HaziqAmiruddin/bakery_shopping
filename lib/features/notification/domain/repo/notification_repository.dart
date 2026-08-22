import 'package:shopping_app/features/notification/domain/entities/app_notification.dart';

abstract class NotificationRepository {
  Future<void> createLoginNotification();

  Stream<List<AppNotification>> getNotifications();
}
