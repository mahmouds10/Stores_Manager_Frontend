// cubits/store/store_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/store_model.dart';
import '../../services/store_service.dart';
import 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreService _storeService;
  StoreCubit(this._storeService) : super(StoreInitial());

  Future<void> loadAllStores() async {
    emit(StoreLoading());
    try {
      final stores = await _storeService.getAllStores();
      emit(StoreLoaded(stores: stores));
    } catch (e) {
      emit(StoreError(message: e.toString()));
    }
  }

  Future<void> loadStoresForProduct(String productId) async {
    emit(StoreLoading());
    try {
      final stores = await _storeService.getStoresForProduct(productId);
      emit(StoreLoaded(stores: stores));
    } catch (e) {
      emit(StoreError(message: e.toString()));
    }
  }
}