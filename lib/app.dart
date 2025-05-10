import 'package:flutter/material.dart';
import 'package:mobile_frontend/screens/stores_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_search_screen.dart';
import '../cubits/product/product_cubit.dart';
import '../cubits/store/store_cubit.dart';
import '../services/product_service.dart';
import '../services/store_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubit Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        "/" : (context) => LandingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/stores': (context) => StoresScreen(),
        '/search-products': (context) => MultiBlocProvider(
          providers: [
            BlocProvider<ProductCubit>(
              create: (_) => ProductCubit(ProductService()),
            ),
            BlocProvider<StoreCubit>(
              create: (_) => StoreCubit(StoreService()),
            ),
          ],
          child: ProductSearchScreen(),
        ),
      },
    );
  }
}
