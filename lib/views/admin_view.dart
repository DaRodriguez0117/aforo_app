import 'dart:async';
import 'dart:developer';

import 'package:aforo_app/views/login_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminView extends StatefulWidget {
  const AdminView({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late final TextEditingController maxCapacityController;

  late int currentCapacity;
  var canEdit = false;

  late final FocusNode focusNode;
  final DatabaseReference ref = FirebaseDatabase.instance.ref('aforo/0');
  late Future<DataSnapshot> future;
  late final StreamSubscription<DatabaseEvent> subscription;

  @override
  void initState() {
    focusNode = FocusNode();
    future = ref.get();
    maxCapacityController = TextEditingController(text: '0');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subscription = ref.child('aforoMaximo').onValue.listen((event) {
        setState(() {
          maxCapacityController.text = event.snapshot.value.toString();
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataSnapshot>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data!.value.toString());
            final map = snapshot.data!.value as Map;

            currentCapacity = map['aforoActual'];

            return Scaffold(
              appBar: AppBar(
                title: Text(map['nombreEstablecimiento']),
                centerTitle: true,
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
                      icon: const Icon(Icons.logout))
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Aforo Máximo',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        enabled: canEdit,
                        focusNode: focusNode,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(
                          fontSize: 70,
                        ),
                        controller: maxCapacityController,
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFC7D3E9),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                      const Text(
                        'Aforo Actual',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      StreamBuilder<DatabaseEvent>(
                        stream: ref.child('aforoActual').onValue,
                        builder: (context, snapshot) {
                          String value = currentCapacity.toString();
                          if (snapshot.hasData) {
                            value = snapshot.data!.snapshot.value.toString();
                          }
                          return Text(
                            value,
                            style: const TextStyle(
                              fontSize: 70,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canEdit ? Colors.green : null,
                          ),
                          onPressed: () {
                            if (canEdit) {
                              if (int.parse(maxCapacityController.text) <
                                  currentCapacity) {
                                const snackBar = SnackBar(
                                  content: Text('Aforo máximo no válido'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                ref.update({
                                  'aforoMaximo':
                                      int.parse(maxCapacityController.text)
                                });
                                setState(() {
                                  canEdit = false;
                                });
                              }
                            } else {
                              setState(() {
                                canEdit = true;
                              });
                              Future.delayed(const Duration(milliseconds: 10),
                                  () {
                                focusNode.requestFocus();
                              });
                            }
                          },
                          icon: Icon(
                            canEdit ? Icons.done : Icons.edit,
                          ),
                          label: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                canEdit ? 'Aceptar' : 'Editar Aforo Máximo',
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text('Cargando datos')
                  ],
                ),
              ),
            );
          }
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
