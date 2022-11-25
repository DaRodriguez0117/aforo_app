import 'package:aforo_app/views/admin_view.dart';
import 'package:aforo_app/views/establishment_view.dart';
import 'package:aforo_app/views/home_view.dart';
import 'package:aforo_app/views/register_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController userController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    userController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            child: Image(
              color: Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.srcOver,
              image: const AssetImage('assets/images/uniciencia.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Image(
                        image: AssetImage('assets/images/uniciencia_logo.png'),
                      ),
                    ),
                  ),
                  const Text(
                    'Bienvenido a\nAforo App',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: userController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: const Icon(Icons.person),
                            hintText: 'Usuario',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: const Icon(Icons.lock),
                            hintText: 'Contraseña',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            if (userController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              if (userController.text == 'user' &&
                                  passwordController.text == '12345') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeView(),
                                  ),
                                );
                              } else if (userController.text == 'admin' &&
                                  passwordController.text == '12345') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EstablishmentView(
                                      id: 0,
                                      establishmentName: 'Gimnasio X-For',
                                      currentCapacity: 25,
                                      maxCapacity: 50,
                                      isAdmin: true,
                                    ),
                                  ),
                                );
                              } else {
                                const snackBar = SnackBar(
                                  content: Text(
                                      'No se encontró ningún usuario válido'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              const snackBar = SnackBar(
                                content: Text('Por favor complete los datos'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (userController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        if (userController.text == 'user' &&
                            passwordController.text == '12345') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                          );
                        } else if (userController.text == 'admin' &&
                            passwordController.text == '12345') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminView()
                                //   id: 0,
                                //   establishmentName: 'Gimnasio X-For',
                                //   currentCapacity: 25,
                                //   maxCapacity: 50,
                                //   isAdmin: true,
                                // ),
                                ),
                          );
                        } else {
                          const snackBar = SnackBar(
                            content:
                                Text('No se encontró ningún usuario válido'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        const snackBar = SnackBar(
                          content: Text('Por favor complete los datos'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: SizedBox(
                      width: size.width * 0.5,
                      child: const Text(
                        'Ingresar',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Si no tiene usuario '),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterView(),
                                ));
                          },
                          child: const Text(
                            'regístrate acá',
                            style: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
