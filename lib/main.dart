import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';

// Services
import 'services/auth_service.dart';
// import 'services/store_service.dart';
// import 'services/product_service.dart';
// import 'services/search_service.dart';

// Cubits
import 'cubits/auth/auth_cubit.dart';
// import 'cubits/store/store_cubit.dart';
// import 'cubits/product/product_cubit.dart';
// import 'cubits/search/search_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthService())),
        // BlocProvider(create: (_) => StoreCubit(StoreService())),
        // BlocProvider(create: (_) => ProductCubit(ProductService())),
        // BlocProvider(create: (_) => SearchCubit(SearchService())),
      ],
      child: const MyApp(),
    ),
  );
}
