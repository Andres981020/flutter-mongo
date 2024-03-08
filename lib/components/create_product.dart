import 'package:flutter/material.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:provider/provider.dart';

class CreateProductAction extends StatelessWidget {
  const CreateProductAction({super.key});

  @override
  Widget build(BuildContext context) {
    return styledFloatingAddButton(context,
        onPressed: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => const Wrap(
                  children: [CreateProductoForm()],
                )));
  }
}

class CreateProductoForm extends StatefulWidget {
  const CreateProductoForm({super.key});

  @override
  createState() => _CreateProductoFormState();
}

class _CreateProductoFormState extends State<CreateProductoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productoEditingController;

  @override
  void initState() {
    _productoEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _productoEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return formLayout(context, 
      Form(key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Crear un nuevo producto", style: theme.titleLarge),
          TextFormField(
            controller: _productoEditingController,
            validator: (value) => (value ?? "").isEmpty ? "Por favor ingresa un texto": null,
          ),
          Padding(padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cancelButton(context),
              Consumer<RealmServices>(builder: (context, realmServices, child) {
                return okButton(context, "Crear", onPressed: () => save(realmServices, context));
              }),
            ],
          ),
          )
        ],
      ),
      ));
  }

  void save(RealmServices realmServices, BuildContext context) {
    if(_formKey.currentState!.validate()) {
      final detalle = _productoEditingController.text;
      realmServices.createProducto(detalle, 15);
      Navigator.pop(context);
    }
  }
}
