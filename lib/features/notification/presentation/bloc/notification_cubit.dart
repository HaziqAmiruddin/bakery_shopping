import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/notification/domain/entities/app_notification.dart';
import 'package:shopping_app/features/notification/domain/usecases/create_login_notification.dart';
import 'package:shopping_app/features/notification/domain/usecases/get_notification.dart';
import 'package:shopping_app/features/notification/presentation/bloc/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final CreateLoginNotification createLoginNotification;
  final GetNotifications getNotifications;

  StreamSubscription<List<AppNotification>>? _notificationSubscription;

  NotificationCubit({
    required this.createLoginNotification,
    required this.getNotifications,
  }) : super(const NotificationInitial());

  Future<void> createLogin() async {
    try {
      await createLoginNotification();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void loadNotifications() {
    print('loadNotifications() called');

    emit(const NotificationLoading());

    _notificationSubscription?.cancel();

    try {
      _notificationSubscription = getNotifications().listen(
        (notifications) {
          print('Cubit received: ${notifications.length} notifications');
          emit(NotificationLoaded(notifications));
        },
        onError: (error) {
          print('Notification stream error: $error');
          emit(NotificationError(error.toString()));
        },
      );
    } catch (e) {
      print('Error in loadNotifications: $e');
      emit(NotificationError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
