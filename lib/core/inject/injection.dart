import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shopping_app/features/notification/data/datasources/notification_datasources.dart';
import 'package:shopping_app/features/notification/data/repo/notification_repository_impl.dart';
import 'package:shopping_app/features/notification/domain/repo/notification_repository.dart';
import 'package:shopping_app/features/notification/domain/usecases/create_login_notification.dart';
import 'package:shopping_app/features/notification/domain/usecases/get_notification.dart';
import 'package:shopping_app/features/notification/presentation/bloc/notification_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // DataSource
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: getIt<NotificationRemoteDataSource>(),
    ),
  );

  // UseCases
  getIt.registerLazySingleton<CreateLoginNotification>(
    () => CreateLoginNotification(getIt<NotificationRepository>()),
  );

  getIt.registerLazySingleton<GetNotifications>(
    () => GetNotifications(getIt<NotificationRepository>()),
  );

  // Cubit
  getIt.registerFactory<NotificationCubit>(
    () => NotificationCubit(
      createLoginNotification: getIt<CreateLoginNotification>(),
      getNotifications: getIt<GetNotifications>(),
    ),
  );
}
