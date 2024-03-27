import 'package:flutter/material.dart';
import 'package:flutter_todo/components/create_product.dart';
import 'package:flutter_todo/components/todo_item.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:flutter_todo/theme.dart';
import 'package:provider/provider.dart';

class TodoProduct extends StatelessWidget {
  final Producto product;
  const TodoProduct(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    bool isMine = (product.ownerId == realmServices.currentUser?.id);
    return product.isValid
        ? ListTile(
            leading: Checkbox(
              value: true,
              onChanged: (bool? value) async {
                if (isMine) {
                  await realmServices.updateProduct(product, 'algo', 15.0);
                } else {
                  errorMessageSnackBar(context, "Cambio no permitido!",
                          "No tiene permitido cambiar el estado de una\n tarea que no le pertenece.")
                      .show(context);
                }
              },
            ),
            title: Text(product.productName),
            subtitle: Text(
              isMine ? '(Propio) ' : '',
              style: boldTextStyle(),
            ),
            trailing: SizedBox(
              width: 25,
              child: PopupMenuButton<MenuOption>(
                onSelected: (menuItem) =>
                    handleMenuClick(context, menuItem, product, realmServices),
                itemBuilder: (context) => [
                  const PopupMenuItem<MenuOption>(
                    value: MenuOption.edit,
                    child: ListTile(
                        leading: Icon(Icons.edit), title: Text("Editar item")),
                  ),
                  const PopupMenuItem<MenuOption>(
                    value: MenuOption.delete,
                    child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text("Eliminar item")),
                  ),
                ],
              ),
            ),
            shape: const Border(bottom: BorderSide()),
          )
        : Container();
  }

  void handleMenuClick(BuildContext context, MenuOption menuItem, Producto product,
      RealmServices realmServices) {
    bool isMine = (product.ownerId == realmServices.currentUser?.id);
    switch (menuItem) {
      case MenuOption.edit:
        if (isMine) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const Wrap(children: [CreateProductoForm()]),
          );
        } else {
          errorMessageSnackBar(context, "Edición no permitida!",
                  "No puedes editar items \n que no te pertenecen.")
              .show(context);
        }
        break;
      case MenuOption.delete:
        if (isMine) {
          realmServices.deleteProducto(product);
        } else {
          errorMessageSnackBar(context, "Eliminación no permitida!",
                  "No puedes eliminar items \n que no te pertenecen.")
              .show(context);
        }
        break;
    }
  }
}