import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shopping_app/core/theme/presentation/bloc/theme_cubit.dart';
import 'package:shopping_app/features/cart/data/the_data/cart_remote_data_source.dart';
import 'package:shopping_app/features/cart/data/repo_imp/repository_implemenntation.dart';
import 'package:shopping_app/features/cart/domain/repo/cart_repo.dart';
import 'package:shopping_app/features/cart/domain/usecase/cart_usecases.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_app/features/home/data/product_data/fav_remote_datasource.dart';
import 'package:shopping_app/features/home/data/product_data/internet_data.dart';
import 'package:shopping_app/features/home/data/repo/fav_repository_impl.dart';
import 'package:shopping_app/features/home/data/repo/product_repo_impl.dart';
import 'package:shopping_app/features/home/domain/repo/fav_repository.dart';
import 'package:shopping_app/features/home/domain/repo/product_repository.dart';
import 'package:shopping_app/features/home/domain/useccase/get_product_usecase.dart';
import 'package:shopping_app/features/home/domain/useccase/toggle_fav.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/category_overview_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/category_product_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/fav_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/online_products_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/product_list_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/fav_event.dart';
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
import 'package:shopping_app/features/address/data/address_remote_data_sources.dart';
import 'package:shopping_app/features/address/data/address_repo_impl.dart';
import 'package:shopping_app/features/helpsupport/data/chat_data.dart';
import 'package:shopping_app/features/helpsupport/data/chat_repo_imp.dart';
import 'package:shopping_app/features/feedback/data/feedback_remote_datasource.dart';
import 'package:shopping_app/features/feedback/data/feedback_repo_imp.dart';
import 'package:shopping_app/features/payment_stripe/data/payment_method_api_service.dart';
import 'package:shopping_app/features/payment_stripe/data/payment_method_repoimpl.dart';
import 'package:shopping_app/features/address/domain/address_repo.dart';
import 'package:shopping_app/features/address/domain/address_usecase.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_repo.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_usecase.dart';
import 'package:shopping_app/features/payment_stripe/domain/card_stripe_usecase.dart';
import 'package:shopping_app/features/feedback/domain/feedback_repo.dart';
import 'package:shopping_app/features/feedback/domain/feedback_usecase.dart';
import 'package:shopping_app/features/payment_stripe/domain/payment_method_repo.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_event.dart';
import 'package:shopping_app/features/helpsupport/presentation/bloc/chat_cubit.dart';
import 'package:shopping_app/features/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:shopping_app/features/payment_stripe/presentation/bloc/payment_method_bloc.dart';
import 'package:shopping_app/features/payment_xendit/data/xendit_api_service.dart';

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

  // DataSource
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: getIt<CartRemoteDataSource>()),
  );

  // UseCases
  getIt.registerLazySingleton<WatchCartUseCase>(
    () => WatchCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<UpdateCartQuantityUseCase>(
    () => UpdateCartQuantityUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(getIt<CartRepository>()),
  );

  // Bloc — this one should be a singleton, not a factory, since the cart
  // needs to persist and stay subscribed across the whole app (badge icon,
  // product cards, cart screen all share the same live state).
  getIt.registerLazySingleton<CartBloc>(
    () => CartBloc(
      watchCartUseCase: getIt<WatchCartUseCase>(),
      addToCartUseCase: getIt<AddToCartUseCase>(),
      updateCartQuantityUseCase: getIt<UpdateCartQuantityUseCase>(),
      removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
      clearCartUseCase: getIt<ClearCartUseCase>(),
    ),
    //..add(WatchCartStarted()),
  );

  getIt.registerFactory<OnlineProductsBloc>(
    () => OnlineProductsBloc(getIt<GetOnlineProductsUseCase>()),
  );

  getIt.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSource(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      remoteDataSource: getIt<FavoriteRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<WatchFavoritesUseCase>(
    () => WatchFavoritesUseCase(getIt<FavoriteRepository>()),
  );
  getIt.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(getIt<FavoriteRepository>()),
  );

  getIt.registerLazySingleton<FavoriteBloc>(
    () => FavoriteBloc(
      watchFavoritesUseCase: getIt<WatchFavoritesUseCase>(),
      toggleFavoriteUseCase: getIt<ToggleFavoriteUseCase>(),
    )..add(WatchFavoritesStarted()),
  );

  getIt.registerLazySingleton<PaymentMethodApiService>(
    () => PaymentMethodApiService(),
  );

  getIt.registerLazySingleton<PaymentMethodRepository>(
    () => PaymentMethodRepositoryImpl(
      apiService: getIt<PaymentMethodApiService>(),
    ),
  );

  getIt.registerLazySingleton<GetSavedCardsUseCase>(
    () => GetSavedCardsUseCase(getIt<PaymentMethodRepository>()),
  );
  getIt.registerLazySingleton<CreatePaymentSheetParamsUseCase>(
    () => CreatePaymentSheetParamsUseCase(getIt<PaymentMethodRepository>()),
  );

  getIt.registerLazySingleton<DeleteCardUseCase>(
    () => DeleteCardUseCase(getIt<PaymentMethodRepository>()),
  );

  getIt.registerFactory<PaymentMethodBloc>(
    () => PaymentMethodBloc(
      getSavedCardsUseCase: getIt<GetSavedCardsUseCase>(),
      deleteCardUseCase: getIt<DeleteCardUseCase>(),
    ),
  );

  getIt.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSource(
      firestore: getIt<FirebaseFirestore>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: getIt<AddressRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<WatchAddressesUseCase>(
    () => WatchAddressesUseCase(getIt<AddressRepository>()),
  );
  getIt.registerLazySingleton<AddAddressUseCase>(
    () => AddAddressUseCase(getIt<AddressRepository>()),
  );
  getIt.registerLazySingleton<UpdateAddressUseCase>(
    () => UpdateAddressUseCase(getIt<AddressRepository>()),
  );
  getIt.registerLazySingleton<DeleteAddressUseCase>(
    () => DeleteAddressUseCase(getIt<AddressRepository>()),
  );
  getIt.registerLazySingleton<SetDefaultAddressUseCase>(
    () => SetDefaultAddressUseCase(getIt<AddressRepository>()),
  );

  getIt.registerLazySingleton<AddressBloc>(
    () => AddressBloc(
      watchAddressesUseCase: getIt<WatchAddressesUseCase>(),
      addAddressUseCase: getIt<AddAddressUseCase>(),
      updateAddressUseCase: getIt<UpdateAddressUseCase>(),
      deleteAddressUseCase: getIt<DeleteAddressUseCase>(),
      setDefaultAddressUseCase: getIt<SetDefaultAddressUseCase>(),
    )..add(WatchAddressesStarted()),
  );

  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  getIt.registerLazySingleton<FeedbackRemoteDataSource>(
    () => FeedbackRemoteDataSource(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<FeedbackRepository>(
    () => FeedbackRepositoryImpl(
      remoteDataSource: getIt<FeedbackRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<SubmitFeedbackUseCase>(
    () => SubmitFeedbackUseCase(getIt<FeedbackRepository>()),
  );

  getIt.registerFactory<FeedbackCubit>(
    () => FeedbackCubit(submitFeedbackUseCase: getIt<SubmitFeedbackUseCase>()),
  );

  getIt.registerLazySingleton<SupportChatApiService>(
    () => SupportChatApiService(),
  );

  getIt.registerLazySingleton<SupportChatRepository>(
    () => SupportChatRepositoryImpl(apiService: getIt<SupportChatApiService>()),
  );

  getIt.registerLazySingleton<SendSupportMessageUseCase>(
    () => SendSupportMessageUseCase(getIt<SupportChatRepository>()),
  );

  getIt.registerFactory<SupportChatCubit>(
    () => SupportChatCubit(
      sendSupportMessageUseCase: getIt<SendSupportMessageUseCase>(),
    ),
  );

  getIt.registerLazySingleton<XenditApiService>(() => XenditApiService());
}
