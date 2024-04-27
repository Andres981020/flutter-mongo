import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/components/todo_product.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:realm/realm.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    final String atlasUrl =
        Provider.of<Config>(context, listen: false).atlasUrl;
    return Stack(
      children: [
        Column(
          children: [
            styledBox(
              context,
              isHeader: true,
              child: Row(
                children: [
                  const Expanded(
                    child: Text("Mostrar todos los productos", textAlign: TextAlign.right),
                  ),
                  Switch(
                    value: realmServices.showAll,
                    onChanged: (value) async {
                      if (realmServices.offlineModeOn) {
                        infoMessageSnackBar(context,
                                "Switching subscriptions does not affect Realm data when the sync is offline.")
                            .show(context);
                      }
                      await realmServices.switchSubscription(value);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: StreamBuilder<RealmResultsChanges<Producto>>(
                  stream: realmServices.realm
                      .query<Producto>("TRUEPREDICATE SORT(_id ASC)")
                      .changes,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    print(data?.results.length);

                    if (data == null) return waitingIndicator();

                    final results = data.results;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: results.realm.isClosed ? 0 : results.length,
                      itemBuilder: (context, index) => results[index].isValid
                          ? TodoProduct(results[index])
                          : Container(),
                    );
                  },
                ),
              ),
            ),
            styledBox(context,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(15, 0, 40, 15),
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                        text: 'Para ver tus cambios en Atlas, ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'presiona aquí.',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 98, 255)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _launchURL(url: atlasUrl),
                      )
                    ])))),
            styledBox(
              context,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 40, 15),
                  child: const Text(
                    "Ingresa con la misma cuenta en otro dispositivo para ver tu lista sincronizarse en tiempo real.",
                    textAlign: TextAlign.left,
                  )),
            ),
          ],
        ),
        realmServices.isWaiting ? waitingIndicator() : Container(),
      ],
    );
  }

  _launchURL({required String url}) async {
    Uri parsedUrl = Uri.parse(url);

    if (url.isNotEmpty) {
      await launchUrl(parsedUrl);
    } else {
      throw 'Could not open $parsedUrl';
    }
  }
}
