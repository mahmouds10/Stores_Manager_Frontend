// cubits/store/store_state.dart
import '../../models/store_model.dart';

abstract class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<StoreModel> stores;
  StoreLoaded({required this.stores});
}

class StoreError extends StoreState {
  final String message;
  StoreError({required this.message});
}