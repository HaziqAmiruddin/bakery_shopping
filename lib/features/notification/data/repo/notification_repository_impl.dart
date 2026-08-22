import 'package:shopping_app/features/notification/data/datasources/notification_datasources.dart';
import 'package:shopping_app/features/notification/domain/entities/app_notification.dart';
import 'package:shopping_app/features/notification/domain/repo/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createLoginNotification() async {
    await remoteDataSource.createLoginNotification();
  }

  @override
  Stream<List<AppNotification>> getNotifications() {
    return remoteDataSource.getNotifications();
  }
}
