import 'package:aforo_app/views/establishment_view.dart';
import 'package:aforo_app/views/login_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EstablishmentView(
                    establishmentName: 'Gimnasio X-For',
                    currentCapacity: 15,
                    maxCapacity: 50,
                  ),
                ),
              );
            },
            title: const Text(
              'Gimnasio X-For',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EstablishmentView(
                    establishmentName: 'Droguería La Cumbre',
                    currentCapacity: 15,
                    maxCapacity: 15,
                  ),
                ),
              );
            },
            title: const Text(
              'Droguería La Cumbre',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EstablishmentView(
                    establishmentName: 'Mas X Menos',
                    currentCapacity: 150,
                    maxCapacity: 170,
                  ),
                ),
              );
            },
            title: const Text(
              'Mas X Menos',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EstablishmentView(
                    establishmentName: 'Banco Davivienda',
                    currentCapacity: 35,
                    maxCapacity: 36,
                  ),
                ),
              );
            },
            title: const Text(
              'Banco Davivienda',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
        ],
      ),
    );
  }
}
