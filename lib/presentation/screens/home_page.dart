import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client.from('users').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final instruments = snapshot.data!;

          return ListView.builder(
            itemCount: instruments.length,

            itemBuilder: ((context, index) {
              final instrument = instruments[index];

              return ListTile(title: Text(instrument['name']));
            }),
          );
        },
      ),
    );
  }
}
