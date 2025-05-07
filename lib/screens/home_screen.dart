import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Loved Stores'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/favorites');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(

            child: Text(
              'No stores available.',
              style: TextStyle(fontSize: 18),

        ),
      ),
    );
  }
}
