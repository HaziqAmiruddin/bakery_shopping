import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:shopping_app/features/notification/presentation/bloc/notification_state.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(title: "Notification"),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          print('Notification State: $state');

          if (state is NotificationInitial) {
            return const Center(child: Text('No notifications'));
          }

          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(child: Text(state.message));
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            print('Notifications received: ${state.notifications.length}');

            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) {
                return const SizedBox(height: 8);
              },
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(
                      notification.type == 'login'
                          ? Icons.login
                          : Icons.notifications,
                    ),
                  ),
                  title: Text(notification.title),
                  subtitle: Text(notification.message),
                  trailing: Text(
                    DateFormat(
                      'dd MMM\nhh:mm a',
                    ).format(notification.timestamp),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
