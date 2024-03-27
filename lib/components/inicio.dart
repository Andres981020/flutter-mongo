import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  void irItems() {
    Navigator.pushNamed(context, '/home');
    print("object");
  }

  void irProductos() {
    Navigator.pushNamed(context, "/productos");
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.only(top: 30),
        child: Form(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                    width: 150,
                    child: OverflowBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: const Text("Boton 1"),
                          onPressed: () => irItems(),
                        ),
                        TextButton(
                          child: const Text("Boton 2"),
                          onPressed: () => irProductos(),
                          )

                        // ElevatedButton(
                        //   child: Text("Boton 1"),
                        //   onPressed: () {}
                        //   )
                      ],
                    ),
                  )
                ],
              ),
              // Row(
              //   children: [
              //     loginButton(context,
              //     onPressed: salir(),
              //     child: const Text("Salir")),
              //   ],
              // )
            ],
          ),
        )),
      ),
    );
  }

  salir() {
    Navigator.pop(context);
  }
}
