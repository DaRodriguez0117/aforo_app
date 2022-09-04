import 'package:aforo_app/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EstablishmentView extends StatefulWidget {
  const EstablishmentView({
    Key? key,
    required this.establishmentName,
    required this.maxCapacity,
    required this.currentCapacity,
    this.isAdmin = false,
  }) : super(key: key);

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

  @override
  void initState() {
    currentCapacity = widget.currentCapacity;
    maxCapacityController =
        TextEditingController(text: widget.maxCapacity.toString());
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.establishmentName),
        centerTitle: true,
        actions: [
          if (widget.isAdmin)
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
      body: Padding(
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
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.isAdmin)
              TextFormField(
                enabled: canEdit,
                focusNode: focusNode,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  fontSize: 100,
                ),
                controller: maxCapacityController,
                decoration: const InputDecoration(
                  fillColor: Color(0xFFC7D3E9),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              )
            else
              Text(
                widget.maxCapacity.toString(),
                style: const TextStyle(
                  fontSize: 100,
                ),
                textAlign: TextAlign.center,
              ),
            const Text(
              'Aforo Actual',
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              currentCapacity.toString(),
              style: const TextStyle(
                fontSize: 100,
              ),
              textAlign: TextAlign.center,
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
            if (widget.isAdmin)
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
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        setState(() {
                          canEdit = false;
                        });
                      }
                    } else {
                      setState(() {
                        canEdit = true;
                      });
                      Future.delayed(const Duration(milliseconds: 10), () {
                        focusNode.requestFocus();
                      });
                    }
                  },
                  icon: Icon(
                    canEdit ? Icons.done : Icons.edit,
                  ),
                  label: SizedBox(
                    height: 50,
                    child: Column(
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
              ),
            if (!widget.isAdmin)
              const Expanded(
                child: SizedBox(),
              ),
            if (!widget.isAdmin)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: didEnter || widget.maxCapacity == currentCapacity
                        ? null
                        : () {
                            setState(() {
                              currentCapacity++;
                              didEnter = true;
                            });
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
                            setState(
                              () {
                                currentCapacity--;
                                didEnter = false;
                              },
                            );
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
    );
  }
}
