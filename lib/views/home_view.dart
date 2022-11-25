import 'package:aforo_app/views/establishment_view.dart';
import 'package:aforo_app/views/login_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('aforo');
  late Future<DataSnapshot> future;

  @override
  void initState() {
    future = ref.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Establecimientos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder<DataSnapshot>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data!.value as List<dynamic>;
                final children = <Widget>[];
                for (var i = 0; i < list.length; i++) {
                  children.add(
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EstablishmentView(
                              id: i,
                              establishmentName: list[i]
                                  ['nombreEstablecimiento'],
                              currentCapacity: list[i]['aforoActual'],
                              maxCapacity: list[i]['aforoMaximo'],
                            ),
                          ),
                        );
                      },
                      title: Text(
                        list[i]['nombreEstablecimiento'],
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ),
                  );
                }
                return Column(children: children);
              } else if (snapshot.hasError) {
                return const Text('Un error');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
