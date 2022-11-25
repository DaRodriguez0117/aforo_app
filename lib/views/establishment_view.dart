import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EstablishmentView extends StatefulWidget {
  const EstablishmentView({
    Key? key,
    required this.id,
    required this.establishmentName,
    required this.maxCapacity,
    required this.currentCapacity,
    this.isAdmin = false,
  }) : super(key: key);

  final int id;
  final String establishmentName;
  final int maxCapacity;
  final int currentCapacity;
  final bool isAdmin;

  @override
  State<EstablishmentView> createState() => _EstablishmentViewState();
}

class _EstablishmentViewState extends State<EstablishmentView> {
  late final TextEditingController maxCapacityController;

  late int currentCapacity;
  var didEnter = false;
  var canEdit = false;

  late final FocusNode focusNode;
  late final DatabaseReference ref;
  late Future<DataSnapshot> future;
  late final StreamSubscription<DatabaseEvent> subscription;

  @override
  void initState() {
    ref = FirebaseDatabase.instance.ref('aforo/${widget.id}');
    currentCapacity = widget.currentCapacity;
    maxCapacityController =
        TextEditingController(text: widget.maxCapacity.toString());
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subscription = ref.child('aforoActual').onValue.listen((event) {
        setState(() {
          currentCapacity = int.parse(event.snapshot.value.toString());
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.establishmentName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: widget.isAdmin
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Aforo Máximo',
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              StreamBuilder<DatabaseEvent>(
                stream: ref.child('aforoMaximo').onValue,
                builder: (context, snapshot) {
                  String value = widget.maxCapacity.toString();
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
              if (widget.maxCapacity == currentCapacity)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '¡Aforo completado!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB61D1D),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: didEnter || widget.maxCapacity == currentCapacity
                        ? null
                        : () {
                            currentCapacity++;
                            ref.update(
                                {'aforoActual': ServerValue.increment(1)});
                            didEnter = true;
                          },
                    icon: const Icon(Icons.add),
                    label: SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Entrada',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB61D1D),
                    ),
                    onPressed: didEnter
                        ? () {
                            currentCapacity--;
                            ref.update(
                                {'aforoActual': ServerValue.increment(-1)});
                            didEnter = false;
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                    label: SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Salida',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
