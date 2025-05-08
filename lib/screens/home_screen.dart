import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/store/store_cubit.dart';
import '../cubits/store/store_state.dart';
import '../models/store_model.dart';
import 'store_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load stores when the screen initializes
    context.read<StoreCubit>().loadAllStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            // ListTile(
            //   leading: const Icon(Icons.favorite),
            //   title: const Text('Loved Stores'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, '/favorites');
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Products'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to product search screen when implemented
                // Navigator.pushNamed(context, '/search-products');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<StoreCubit, StoreState>(
          builder: (context, state) {
            if (state is StoreLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StoreError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (state is StoreLoaded) {
              return _buildStoresList(state.stores);
            }
            return const Center(
              child: Text(
                'No stores available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStoresList(List<StoreModel> stores) {
    if (stores.isEmpty) {
      return const Center(
        child: Text(
          'No stores available.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return _buildStoreCard(context, store);
      },
    );
  }

  Widget _buildStoreCard(BuildContext context, StoreModel store) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreProductsScreen(
                storeId: store.id,
                storeName: store.name,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: store.type == 'restaurant'
                      ? Colors.orange.shade100
                      : Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  store.type == 'restaurant' ? Icons.restaurant : Icons.coffee,
                  size: 32,
                  color: store.type == 'restaurant'
                      ? Colors.orange.shade800
                      : Colors.brown.shade800,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      store.type.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}