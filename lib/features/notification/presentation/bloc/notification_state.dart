import 'package:shopping_app/features/notification/domain/entities/app_notification.dart';

sealed class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;

  const NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);
}
