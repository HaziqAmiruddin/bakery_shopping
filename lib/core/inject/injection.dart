import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shopping_app/features/home/data/product_data/internet_data.dart';
import 'package:shopping_app/features/home/data/repo/product_repo_impl.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';
import 'package:shopping_app/features/home/domain/useccase/get_all_products_usecase.dart';
import 'package:shopping_app/features/home/domain/useccase/get_featured_products_usecase.dart';
import 'package:shopping_app/features/home/domain/useccase/get_new_products_usecase.dart';
import 'package:shopping_app/features/home/domain/useccase/get_online_products_usecase.dart';
import 'package:shopping_app/features/home/domain/useccase/get_popular_products_useccase.dart';
import 'package:shopping_app/features/home/domain/useccase/get_product_by_category_usecase.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/category_overview_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/category_product_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/product_list_bloc.dart';
import 'package:shopping_app/features/map/data/location_data_sources.dart';
import 'package:shopping_app/features/map/domain/repository/location_repo.dart';
import 'package:shopping_app/features/map/domain/usecases/get_address_from_coordinates.dart';
import 'package:shopping_app/features/map/domain/usecases/get_coordinates_from_address.dart';
import 'package:shopping_app/features/map/domain/usecases/get_current_location.dart';
import 'package:shopping_app/features/map/presentation/bloc/location_bloc.dart';
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

  // Repository
  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => GetCurrentLocation(getIt<LocationRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAddressFromCoordinates(getIt<LocationRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCoordinatesFromAddress(getIt<LocationRepository>()),
  );

  // Bloc — factory, not singleton, since Blocs shouldn't usually be reused across app restarts/screens indefinitely
  getIt.registerFactory(
    () => LocationBloc(
      getCurrentLocation: getIt<GetCurrentLocation>(),
      getAddressFromCoordinates: getIt<GetAddressFromCoordinates>(),
      getCoordinatesFromAddress: getIt<GetCoordinatesFromAddress>(),
    ),
  );

  // Repository
  //getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());

  // UseCase
  getIt.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(getIt<ProductRepository>()),
  );

  // Bloc — factory, since each CategoryProductsScreen should get a fresh bloc
  getIt.registerFactory<CategoryProductsBloc>(
    () => CategoryProductsBloc(getIt<GetProductsByCategoryUseCase>()),
  );

  getIt.registerLazySingleton<GetAllProductsUseCase>(
    () => GetAllProductsUseCase(getIt<ProductRepository>()),
  );

  getIt.registerFactory<CategoryOverviewBloc>(
    () => CategoryOverviewBloc(getIt<GetAllProductsUseCase>()),
  );

  getIt.registerLazySingleton<GetFeaturedProductsUseCase>(
    () => GetFeaturedProductsUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<GetNewProductsUseCase>(
    () => GetNewProductsUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton<GetPopularProductsUseCase>(
    () => GetPopularProductsUseCase(getIt<ProductRepository>()),
  );

  getIt.registerFactory<ProductListBloc>(
    () => ProductListBloc(
      getFeaturedProductsUseCase: getIt<GetFeaturedProductsUseCase>(),
      getNewProductsUseCase: getIt<GetNewProductsUseCase>(),
      getPopularProductsUseCase: getIt<GetPopularProductsUseCase>(),
      getOnlineProductsUseCase: getIt<GetOnlineProductsUseCase>(),
    ),
  );

  // Repository — now needs ProductApiService
  getIt.registerLazySingleton<ProductApiService>(() => ProductApiService());

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(apiService: getIt<ProductApiService>()),
  );

  // UseCase
  getIt.registerLazySingleton<GetOnlineProductsUseCase>(
    () => GetOnlineProductsUseCase(getIt<ProductRepository>()),
  );
}
