part of 'promo_bloc.dart';

@immutable
abstract class PromoEvent {
  const PromoEvent();
}

class GetPromo extends PromoEvent {
  final CHttp? http;

  const GetPromo({this.http});
}
