import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../cubits/product/product_cubit.dart';
import '../cubits/product/product_state.dart';
import '../cubits/store/store_cubit.dart';
import '../cubits/store/store_state.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  ProductModel? selectedProduct;
  bool showMap = false;
  GoogleMapController? mapController;
  Position? userPosition;
  String? locationError;
  bool isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadAllProducts();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      isGettingLocation = true;
      locationError = null;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationError = 'Location services are disabled. Please enable them and retry.';
          isGettingLocation = false;
        });
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationError = 'Location permission denied. Please allow location access.';
            isGettingLocation = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationError = 'Location permission permanently denied. Please enable it from app settings.';
          isGettingLocation = false;
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        userPosition = pos;
        isGettingLocation = false;
        locationError = null;
      });
    } catch (e) {
      setState(() {
        locationError = 'Failed to get location: \\${e.toString()}';
        isGettingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search by Product'),
        backgroundColor: theme.colorScheme.primary,
        elevation: 4,
        actions: [
          if (selectedProduct != null)
            IconButton(
              icon: Icon(showMap ? Icons.list : Icons.map, color: Colors.white),
              onPressed: () => setState(() => showMap = !showMap),
              tooltip: showMap ? 'Show List' : 'Show Map',
            ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, productState) {
          if (productState is ProductLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading products...', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          } else if (productState is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(productState.message, style: const TextStyle(color: Colors.red, fontSize: 16)),
                ],
              ),
            );
          } else if (productState is ProductLoaded) {
            return _buildProductDropdown(productState.products, theme);
          }
          return const Center(child: Text('No products available.'));
        },
      ),
      backgroundColor: theme.colorScheme.background.withOpacity(0.98),
    );
  }

  Widget _buildProductDropdown(List<ProductModel> products, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
      child: Column(
        children: [
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<ProductModel>(
                value: selectedProduct,
                decoration: InputDecoration(
                  labelText: 'Select a product',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: products.map((product) {
                  return DropdownMenuItem<ProductModel>(
                    value: product,
                    child: Row(
                      children: [
                        if (product.productPhoto?.url != null)
                          CircleAvatar(
                            backgroundImage: NetworkImage(product.productPhoto!.url),
                            radius: 14,
                          )
                        else
                          const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 14,
                            child: Icon(Icons.fastfood, color: Colors.white, size: 16),
                          ),
                        const SizedBox(width: 10),
                        Text(product.name, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (product) {
                  setState(() {
                    selectedProduct = product;
                  });
                  if (product != null) {
                    context.read<StoreCubit>().loadStoresForProduct(product.id);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (selectedProduct != null)
            Expanded(
              child: BlocBuilder<StoreCubit, StoreState>(
                builder: (context, storeState) {
                  if (storeState is StoreLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading restaurants/cafes...', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    );
                  } else if (storeState is StoreError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(storeState.message, style: const TextStyle(color: Colors.red, fontSize: 16)),
                        ],
                      ),
                    );
                  } else if (storeState is StoreLoaded) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: showMap
                          ? _buildMapView(storeState.stores)
                          : _buildListView(storeState.stores, theme),
                    );
                  }
                  return const Center(child: Text('No results.'));
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView(List<StoreModel> stores, ThemeData theme) {
    if (stores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search_off, color: Colors.grey, size: 48),
            SizedBox(height: 12),
            Text('No restaurants/cafes found.', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: stores.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final store = stores[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: CircleAvatar(
              backgroundColor: store.type == 'restaurant' ? Colors.orange.shade100 : Colors.brown.shade100,
              child: Icon(
                store.type == 'restaurant' ? Icons.restaurant : Icons.coffee,
                color: store.type == 'restaurant' ? Colors.orange.shade800 : Colors.brown.shade800,
              ),
            ),
            title: Text(store.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            subtitle: userPosition != null
                ? Text('Distance: ' + _formatDistance(_calculateDistance(userPosition!, store)), style: const TextStyle(fontSize: 14))
                : null,
            trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary, size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreDirectionsScreen(
                    store: store,
                    userPosition: userPosition,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMapView(List<StoreModel> stores) {
    if (isGettingLocation) {
      return const Center(child: CircularProgressIndicator());
    }
    if (locationError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationError!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getUserLocation,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (userPosition == null) {
      return const Center(child: Text('Getting your location...'));
    }
    final markers = stores.map((store) {
      return Marker(
        markerId: MarkerId(store.id),
        position: LatLng(store.latitude, store.longitude),
        infoWindow: InfoWindow(title: store.name),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreDirectionsScreen(
                store: store,
                userPosition: userPosition,
              ),
            ),
          );
        },
      );
    }).toSet();
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(userPosition!.latitude, userPosition!.longitude),
        zoom: 13,
      ),
      myLocationEnabled: true,
      markers: markers,
      onMapCreated: (controller) => mapController = controller,
    );
  }

  double _calculateDistance(Position user, StoreModel store) {
    return Geolocator.distanceBetween(
      user.latitude,
      user.longitude,
      store.latitude,
      store.longitude,
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
  }
}

class StoreDirectionsScreen extends StatelessWidget {
  final StoreModel store;
  final Position? userPosition;

  const StoreDirectionsScreen({Key? key, required this.store, required this.userPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userPosition == null) {
      return Scaffold(
        appBar: AppBar(title: Text(store.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Getting your location...'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(userPosition!.latitude, userPosition!.longitude),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('user'),
            position: LatLng(userPosition!.latitude, userPosition!.longitude),
            infoWindow: const InfoWindow(title: 'You'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
          Marker(
            markerId: MarkerId(store.id),
            position: LatLng(store.latitude, store.longitude),
            infoWindow: InfoWindow(title: store.name),
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: [
              LatLng(userPosition!.latitude, userPosition!.longitude),
              LatLng(store.latitude, store.longitude),
            ],
          ),
        },
      ),
    );
  }
} 