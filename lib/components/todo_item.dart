import 'package:flutter/material.dart';
import 'package:flutter_todo/components/modify_item.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:flutter_todo/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/realm_services.dart';

enum MenuOption { edit, delete }

class TodoItem extends StatelessWidget {
  final Item item;

  const TodoItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    bool isMine = (item.ownerId == realmServices.currentUser?.id);
    return item.isValid
        ? ListTile(
            leading: Checkbox(
              value: item.isComplete,
              onChanged: (bool? value) async {
                if (isMine) {
                  await realmServices.updateItem(item,
                      isComplete: value ?? false);
                } else {
                  errorMessageSnackBar(context, "Cambio no permitido!",
                          "No tiene permitido cambiar el estado de una\n tarea que no le pertenece.")
                      .show(context);
                }
              },
            ),
            title: Text(item.summary),
            subtitle: Text(
              isMine ? '(Propio) ' : '',
              style: boldTextStyle(),
            ),
            trailing: SizedBox(
              width: 25,
              child: PopupMenuButton<MenuOption>(
                onSelected: (menuItem) =>
                    handleMenuClick(context, menuItem, item, realmServices),
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

  void handleMenuClick(BuildContext context, MenuOption menuItem, Item item,
      RealmServices realmServices) {
    bool isMine = (item.ownerId == realmServices.currentUser?.id);
    switch (menuItem) {
      case MenuOption.edit:
        if (isMine) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => Wrap(children: [ModifyItemForm(item)]),
          );
        } else {
          errorMessageSnackBar(context, "Edición no permitida!",
                  "No puedes editar items \n que no te pertenecen.")
              .show(context);
        }
        break;
      case MenuOption.delete:
        if (isMine) {
          realmServices.deleteItem(item);
        } else {
          errorMessageSnackBar(context, "Eliminación no permitida!",
                  "No puedes eliminar items \n que no te pertenecen.")
              .show(context);
        }
        break;
    }
  }
}
