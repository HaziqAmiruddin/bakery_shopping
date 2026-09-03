// presentation/bloc/payment_method/payment_method_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/profile/domain/delete_card_usecase.dart';
import 'package:shopping_app/features/profile/domain/get_save_card_usecase.dart';
import 'package:shopping_app/features/profile/presentation/bloc/payment_event.dart';
import 'package:shopping_app/features/profile/presentation/bloc/payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetSavedCardsUseCase getSavedCardsUseCase;
  final DeleteCardUseCase deleteCardUseCase;

  PaymentMethodBloc({
    required this.getSavedCardsUseCase,
    required this.deleteCardUseCase,
  }) : super(PaymentMethodLoading()) {
    on<FetchSavedCards>(_onFetchSavedCards);
    on<DeleteCardPressed>(_onDeleteCardPressed);
  }

  Future<void> _onFetchSavedCards(
    FetchSavedCards event,
    Emitter<PaymentMethodState> emit,
  ) async {
    emit(PaymentMethodLoading());
    try {
      final cards = await getSavedCardsUseCase(event.uid);
      emit(PaymentMethodLoaded(cards));
    } catch (e) {
      emit(PaymentMethodError(e.toString()));
    }
  }

  Future<void> _onDeleteCardPressed(
    DeleteCardPressed event,
    Emitter<PaymentMethodState> emit,
  ) async {
    try {
      await deleteCardUseCase(event.paymentMethodId);
      final cards = await getSavedCardsUseCase(event.uid);
      emit(PaymentMethodLoaded(cards));
    } catch (e) {
      emit(PaymentMethodError(e.toString()));
    }
  }
}
