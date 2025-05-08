// cubits/product/product_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _productService;
  ProductCubit(this._productService) : super(ProductInitial());

  Future<void> loadAllProducts() async {
    emit(ProductLoading());
    try {
      final products = await _productService.getAllProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> loadProductsForStore(String storeId) async {
    emit(ProductLoading());
    try {
      final products = await _productService.getProductsForStore(storeId);
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}