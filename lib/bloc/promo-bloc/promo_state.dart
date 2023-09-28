part of 'promo_bloc.dart';

@immutable
abstract class PromoState {
  const PromoState();
}

class PromoInitial extends PromoState {
  const PromoInitial();

  List<Object> get props => [];
}

// Fetch Promo
class GetPromoLoading extends PromoState {
  const GetPromoLoading();

  List<Object>? get props => null;
}

class GetPromoLoaded extends PromoState {
  final PromoModel promoModel;
  const GetPromoLoaded(this.promoModel);

  List<Object?> get props => [promoModel];
}

class GetPromoError extends PromoState {
  final String message;

  const GetPromoError(this.message);
  List<Object> get props => [message];
}
